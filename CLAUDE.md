# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Sublime Text Development
```bash
# Install in Sublime Text
cd ~/Library/Application\ Support/Sublime\ Text/Packages/
git clone <repo-url> Scrawl
# Restart Sublime Text to load changes

# Test changes
# Open test files in Sublime Text:
# - tests/test.scrawl
# - sublime_text/test.scrawl
```

### VS Code Extension Development
```bash
# Build VSIX package
cd vscode
npm install -g @vscode/vsce  # Install if needed
vsce package

# Install extension locally
code --install-extension scrawl-language-*.vsix

# Manual installation (alternative)
mkdir -p ~/.vscode/extensions/scrawl-language
cp -r vscode/* ~/.vscode/extensions/scrawl-language/
```

### Testing
- **Manual testing only** - no automated test framework
- Test files: `tests/test.scrawl`, `sublime_text/test.scrawl`, `vscode/test.scrawl`
- Verify syntax highlighting by opening `.scrawl` files in each editor
- Test code blocks with various languages to ensure proper highlighting
- Check URL underlining (Sublime) and linking (VS Code)
- Verify section folding with `##SectionName##` tags

## Architecture

Scrawl is a custom note-taking markup language with dual-editor support. Both implementations must maintain feature parity.

### Core Design Philosophy
- **TextMate Grammar System**: Both editors use TextMate-compatible grammars (YAML for Sublime, JSON for VS Code)
- **Language Scope Injection**: Code blocks embed external language scopes for syntax highlighting
- **Parallel Implementations**: Features must be implemented in both editors with equivalent behavior

### Directory Structure
```
sublime_text/
  ├── Scrawl.sublime-syntax              # YAML grammar (325 lines)
  ├── force_url_underline.py             # Python plugin for URL styling
  ├── scrawl_code_block.sublime-completions  # Auto-completions for code blocks
  ├── note-header.sublime-snippet        # Header template snippet
  └── tag.sublime-snippet                # Section tag snippet

vscode/
  ├── package.json                       # Extension manifest
  ├── language-configuration.json        # Comment/bracket config
  └── syntaxes/
      └── scrawl.tmLanguage.json         # JSON grammar (606 lines)
```

### Language Features Implementation

#### 1. Code Block Syntax Highlighting
- **Pattern**: Triple backtick fenced blocks with language identifier
- **Implementation**: Uses `embed` (Sublime) or `include` (VS Code) to inject language-specific scopes
- **Supported Languages**: TypeScript, JavaScript, Python, Ruby, C, C++, C#, Java, HTML, CSS, PHP, Go, Rust, Bash, SQL, JSON, XML, YAML, Markdown
- **Scope Mapping Examples**:
  - `python|py` → `scope:source.python`
  - `typescript|ts` → `scope:source.ts`
  - `c++|cpp|cxx` → `scope:source.c++`
  - `bash|sh|shell|zsh` → `scope:source.shell`

**Adding a new language**:
1. Add language alias to `variables` section in Sublime syntax
2. Create new `fenced_code_block_<language>` pattern with embed directive
3. Add corresponding pattern in VS Code JSON with `contentName` and `patterns` include
4. Update auto-completions in `scrawl_code_block.sublime-completions`

#### 2. URL Highlighting
- **Sublime Text**: Custom Python plugin (`force_url_underline.py`) uses ViewEventListener
  - Runs regex on file load/modification: `(https?:\/\/|www\.)[a-zA-Z0-9][-a-zA-Z0-9]*(\.[a-zA-Z0-9][-a-zA-Z0-9]*)+(/[-a-zA-Z0-9_%&=\?\.~#]*)*`
  - Uses `add_regions()` API with `DRAW_SOLID_UNDERLINE` flag
  - Applies scope `markup.underline.link.url` with custom color `#66D9EF`
- **VS Code**: Built into grammar as pattern with `markup.underline.link.url` scope

#### 3. Section Folding
- **Pattern**: `##SectionName##` creates foldable regions
- **Sublime**: Grammar matches pattern with scope `markup.bold.tag entity.name.section.folding`
- **VS Code**: Folding markers in `language-configuration.json`:
  - Start: `^\\s*##\\s*[a-zA-Z0-9- \\t]+\\s*##`
  - End: `^\\s*##\\s*End\\s*##`

#### 4. Date Headers
- **Format**: Block comment with decorative borders and date
- **Implementation**: Two-tier matching:
  1. Specific format: `/\*\s*\n\s*\*-*\s*\n\s*\*\s*/+\s*\n\s*\*\s*\d+/\d+/\d+\s*\w+\s*\n\s*\*\s*/+\s*\n\s*\*-*\s*\n\s*\*/`
  2. Fallback: Generic `/*` to `*/` block comment with header content scope
- **Scope**: `comment.block markup.heading.note-header`

#### 5. Comments
- **Line comments**: `//` → scope `comment.line`
- **Block comments**: `/* */` → scope `comment.block`
- **Configuration**: Defined in VS Code's `language-configuration.json` for comment toggling

### Grammar Synchronization Strategy

When making changes to language features:

1. **Sublime Text First** (YAML is more readable for design):
   - Edit `sublime_text/Scrawl.sublime-syntax`
   - Test in Sublime Text

2. **Port to VS Code** (JSON is more verbose):
   - Convert YAML patterns to JSON in `vscode/syntaxes/scrawl.tmLanguage.json`
   - Adjust scope references (Sublime uses `scope:` prefix, VS Code uses direct scope names)
   - Test in VS Code

3. **Pattern Conversion Examples**:
   ```yaml
   # Sublime YAML
   - match: '^(\s*)(`{3,})(python|py)(\s*)$'
     embed: scope:source.python
     embed_scope: markup.raw.block.markdown source.python
     escape: '^(\s*)(`{3,})(\s*)$'
   ```

   ```json
   // VS Code JSON
   {
     "begin": "^(\\s*)(`{3,})(python|py)(\\s*)$",
     "end": "^(\\s*)(`{3,})(\\s*)$",
     "contentName": "markup.raw.block.markdown meta.embedded.block.python",
     "patterns": [{"include": "source.python"}]
   }
   ```

### Key Files and Their Purposes

- `Scrawl.sublime-syntax`: Complete syntax definition with all patterns (YAML)
- `scrawl.tmLanguage.json`: Complete syntax definition with all patterns (JSON)
- `force_url_underline.py`: Runtime URL styling for Sublime (no VS Code equivalent needed)
- `language-configuration.json`: VS Code editor behavior (brackets, comments, folding)
- `scrawl_code_block.sublime-completions`: 30+ language completions for code blocks
- `*.sublime-snippet`: Template snippets (note-header, tag) for quick insertion

### Common Maintenance Tasks

**Adding a new code block language**:
1. Identify TextMate scope (e.g., `source.swift` for Swift)
2. Add to Sublime's `variables` section with aliases
3. Create embed pattern in Sublime YAML
4. Create equivalent begin/end pattern in VS Code JSON
5. Add to completions file

**Modifying folding behavior**:
- Sublime: Edit `scope: markup.bold.tag entity.name.section.folding` pattern
- VS Code: Edit `folding.markers` in `language-configuration.json`

**Changing comment styles**:
- Sublime: Edit patterns in `main` context (line_comment, block_comment)
- VS Code: Edit both grammar patterns AND `comments` section in `language-configuration.json`