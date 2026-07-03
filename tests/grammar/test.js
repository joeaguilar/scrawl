// Grammar tests for Scrawl.
//
// Tokenizes representative Scrawl samples through the real TextMate engine
// (vscode-textmate + oniguruma) and asserts the scopes the VS Code grammar
// produces. Also validates that the Sublime syntax parses as YAML and that
// the extension manifest / language configuration are well-formed JSON.
//
// Run: npm ci && npm test   (from tests/grammar/)

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');
const vsctm = require('vscode-textmate');
const oniguruma = require('vscode-oniguruma');

const ROOT = path.join(__dirname, '..', '..');
const GRAMMAR = path.join(ROOT, 'vscode', 'syntaxes', 'scrawl.tmLanguage.json');
const LANG_CONFIG = path.join(ROOT, 'vscode', 'language-configuration.json');
const MANIFEST = path.join(ROOT, 'vscode', 'package.json');
const SUBLIME_SYNTAX = path.join(ROOT, 'sublime_text', 'Scrawl.sublime-syntax');

const failures = [];
function check(name, ok, detail) {
  console.log(`${ok ? 'PASS' : 'FAIL'}  ${name}`);
  if (!ok) failures.push({ name, detail });
}

// ---------------------------------------------------------------------------
// Static file validation
// ---------------------------------------------------------------------------
function validateFiles() {
  check('vscode grammar is valid JSON', (() => {
    try { JSON.parse(fs.readFileSync(GRAMMAR, 'utf8')); return true; } catch { return false; }
  })());
  check('language-configuration is valid JSON', (() => {
    try { JSON.parse(fs.readFileSync(LANG_CONFIG, 'utf8')); return true; } catch { return false; }
  })());
  check('extension manifest is valid JSON with required publish fields', (() => {
    try {
      const m = JSON.parse(fs.readFileSync(MANIFEST, 'utf8'));
      return Boolean(m.repository && m.license && m.publisher);
    } catch { return false; }
  })());
  check('sublime syntax is valid YAML', (() => {
    try { return Boolean(yaml.load(fs.readFileSync(SUBLIME_SYNTAX, 'utf8')).contexts); } catch { return false; }
  })());

  // Folding markers: ##End## must be an end marker only, never a start;
  // parenthesized titles must fold.
  const cfg = JSON.parse(fs.readFileSync(LANG_CONFIG, 'utf8'));
  const start = new RegExp(cfg.folding.markers.start);
  const end = new RegExp(cfg.folding.markers.end);
  check('folding: ##Section## is a start marker', start.test('##Some Section##'));
  check('folding: ##Title (notes)## is a start marker', start.test('##Title (notes)##'));
  check('folding: ##End## is NOT a start marker', !start.test('##End##'));
  check('folding: ##End## is an end marker', end.test('##End##'));
  check('folding: ##Endgame## is still a start marker', start.test('##Endgame##'));
}

// ---------------------------------------------------------------------------
// Tokenization assertions (VS Code grammar through the real engine)
// ---------------------------------------------------------------------------
async function tokenizationChecks() {
  const wasmPath = path.join(__dirname, 'node_modules', 'vscode-oniguruma', 'release', 'onig.wasm');
  await oniguruma.loadWASM(fs.readFileSync(wasmPath).buffer);
  const registry = new vsctm.Registry({
    onigLib: Promise.resolve({
      createOnigScanner: (s) => new oniguruma.OnigScanner(s),
      createOnigString: (s) => new oniguruma.OnigString(s),
    }),
    loadGrammar: async (scopeName) =>
      scopeName === 'text.scrawl'
        ? vsctm.parseRawGrammar(fs.readFileSync(GRAMMAR, 'utf8'), GRAMMAR)
        : null, // embedded languages not needed for these assertions
  });
  const grammar = await registry.loadGrammar('text.scrawl');

  const sample = [
    '##Closed Section##',            // 0
    '## unclosed section',           // 1
    'plain text after stray',        // 2
    '[ ] task - e@2h30m ok',         // 3
    'mail jane@example.com now',     // 4
    '<<|',                           // 5
    'inside multiline highlight',    // 6
    '|>>',                           // 7
    'after highlight normal',        // 8
    'text with unclosed <<| marker', // 9
    'still same paragraph',          // 10
    '',                              // 11
    'next paragraph is safe',        // 12
    '<<| single line |>> tail',      // 13
    '/* note from 3/22/2025 Sat */', // 14
    '[!0] Critical task title',      // 15
    '- list with https://example.com/path link', // 16
  ];

  const perLine = [];
  let rs = vsctm.INITIAL;
  for (const line of sample) {
    const r = grammar.tokenizeLine(line, rs);
    perLine.push(r.tokens.map((t) => ({
      text: line.slice(t.startIndex, t.endIndex),
      scopes: t.scopes.join(' '),
    })));
    rs = r.ruleStack;
  }

  const hasScope = (i, needle) => perLine[i].some((t) => t.scopes.includes(needle));
  const tokenScoped = (i, text, needle) =>
    perLine[i].some((t) => t.text.includes(text) && t.scopes.includes(needle));

  check('section: closed section content styled',
    tokenScoped(0, 'Closed Section', 'keyword.control.section.scrawl'));
  check('section: stray ## does not bleed to next line',
    !hasScope(2, 'keyword.control.section.scrawl'));
  check('e@: estimate in task notes highlighted',
    tokenScoped(3, 'e@2h30m', 'entity.name.function.scrawl'));
  check('e@: not highlighted inside email addresses',
    !tokenScoped(4, 'e@', 'entity.name.function.scrawl'));
  check('highlight: multi-line content styled',
    hasScope(6, 'invalid.illegal.highlight.scrawl'));
  check('highlight: closed by |>>',
    !hasScope(8, 'invalid.illegal.highlight.scrawl'));
  check('highlight: unclosed <<| styles its own paragraph',
    hasScope(10, 'invalid.illegal.highlight.scrawl'));
  check('highlight: unclosed <<| stops at blank line',
    !hasScope(12, 'invalid.illegal.highlight.scrawl'));
  check('highlight: single-line form still closes',
    tokenScoped(13, 'single line', 'invalid.illegal.highlight.scrawl') &&
    !tokenScoped(13, 'tail', 'invalid.illegal.highlight.scrawl'));
  check('comments: date inside block comment highlighted',
    tokenScoped(14, '3/22/2025', 'constant.numeric.date.scrawl'));
  check('tasks: priority task title styled',
    tokenScoped(15, 'Critical task title', 'keyword.control.scrawl'));
  check('urls: link inside list item underlined',
    tokenScoped(16, 'https://example.com/path', 'markup.underline.link.url'));
}

(async () => {
  validateFiles();
  await tokenizationChecks();
  if (failures.length) {
    console.error(`\n${failures.length} check(s) failed`);
    process.exit(1);
  }
  console.log('\nAll grammar checks passed');
})().catch((e) => { console.error(e); process.exit(2); });
