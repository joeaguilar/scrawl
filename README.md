# Scrawl

A custom note-taking markup language with rich editor support for **Sublime Text**, **VS Code**, and **VS Code-compatible editors** (Cursor, Windsurf, VSCodium, and friends). Scrawl is designed to make structured note-taking more organized, visually appealing, and feature-rich within your favorite text editor.

## What is Scrawl?

Scrawl is a specialized markup format that enhances plain text note-taking with:
- Structured headers with date formatting
- Foldable section organization using tags
- Rich code block support with syntax highlighting
- URL highlighting and linking
- Comment support
- Auto-completion and snippets

## Features

### 📝 **Structured Note Format**
- **Date Headers**: Decorative header blocks with date formatting
- **Section Tags**: Organize content with `##SectionName##` syntax that supports folding
- **Comments**: Both line comments (`//`) and block comments (`/* */`)

### 🎨 **Rich Syntax Highlighting**
- Custom color schemes optimized for note-taking
- URL highlighting and linking
- Proper highlighting for all Scrawl elements

### 💻 **Code Block Support**
Embedded code blocks with syntax highlighting for:
- **Web**: TypeScript, JavaScript, HTML, CSS, PHP
- **Systems**: C, C++, C#, Java, Go, Rust
- **Scripting**: Python, Ruby, Bash/Shell
- **Data**: SQL, JSON, XML, YAML
- **Documentation**: Markdown

### ⚡ **Editor Features**
- Auto-completion and snippets
- Bracket auto-pairing
- Symbol navigation
- Code folding
- Comment toggling

## File Extensions

Scrawl supports two file extensions:
- `.scrawl`
- `.note`

## Installation

### Recommended: install script

From the repository root:

```bash
./install.sh
```

The script symlinks the Sublime package and the VS Code extension into every
editor it detects: Sublime Text, VS Code, VS Code Insiders, VSCodium, Cursor,
Windsurf, Trae, Kiro, and Positron. All VS Code forks share the same extension
format, so the single `vscode/` folder serves them all. Symlinks mean grammar
edits in this repo go live after a window reload — handy for development.

After installing, fully quit and relaunch the editor (a plain window reload is
not enough for the extension scanner to pick up a new install).

### Sublime Text (manual)

1. Clone this repository into your Sublime Text packages directory:
   ```bash
   cd ~/Library/Application\ Support/Sublime\ Text/Packages/
   git clone https://github.com/yourusername/Scrawl.git
   ```
2. Restart Sublime Text

### VS Code and compatible editors (manual)

Each VS Code-family editor keeps its own extensions directory:

| Editor | Extensions directory |
|--------|----------------------|
| VS Code | `~/.vscode/extensions` |
| VS Code Insiders | `~/.vscode-insiders/extensions` |
| VSCodium | `~/.vscode-oss/extensions` |
| Cursor | `~/.cursor/extensions` |
| Windsurf | `~/.windsurf/extensions` |

Symlink (or copy) the `vscode/` folder into the target directory **as
`scrawl`**, then fully restart the editor:

```bash
ln -s /path/to/Scrawl/vscode ~/.cursor/extensions/scrawl
```

> ⚠️ Install under exactly one name per editor. Two folders/symlinks pointing
> at the same extension (e.g. both `scrawl` and `scrawl-language`) give the
> editor the same extension ID twice; the scanner then marks the ID obsolete
> and the language silently disappears from the language picker. If that
> happens, delete the duplicate and remove the `scrawl.scrawl-*` entry from
> `<extensions dir>/.obsolete`, then fully restart the editor.

#### Package Installation (VSIX)

A packaged VSIX installs into any VS Code fork via that fork's CLI:

1. Install the VS Code Extension Manager:
   ```bash
   npm install -g @vscode/vsce
   ```
2. Build the package:
   ```bash
   cd vscode
   vsce package
   ```
3. Install the generated VSIX file with your editor's CLI:
   ```bash
   code --install-extension scrawl-*.vsix       # VS Code
   cursor --install-extension scrawl-*.vsix     # Cursor
   windsurf --install-extension scrawl-*.vsix   # Windsurf
   codium --install-extension scrawl-*.vsix     # VSCodium
   ```

To distribute publicly to the forks, publish to [Open VSX](https://open-vsx.org)
(`npx ovsx publish`) — most VS Code forks default to the Open VSX registry
because the Microsoft Marketplace is licensed for official VS Code builds only.

## Usage Examples

### Basic Note Structure

```scrawl
/*
*------------------------
* ///////////////////////
*  3/22/2025 Saturday
* ///////////////////////
*------------------------
*/

##Meeting Notes##

// This is a line comment
Key discussion points:
- Project timeline
- Resource allocation
- Next steps

##Action Items##

/* This is a block comment
   spanning multiple lines */

1. Follow up with team lead
2. Review documentation at https://example.com
3. Schedule next meeting

##Code Examples##

Here's a Python snippet:

```python
def calculate_total(items):
    return sum(item.price for item in items)
```

And some JavaScript:

```javascript
const processData = (data) => {
    return data.map(item => ({
        ...item,
        processed: true
    }));
};
```

##End##
```

### Snippets

#### Sublime Text
- **Note Header**: Type `note-header` + Tab
- **Tag**: Type `tag` + Tab

#### VS Code
- Auto-completion available for common patterns
- Use `Ctrl+Space` (or `Cmd+Space` on Mac) for suggestions

## Project Structure

```
Scrawl/
├── README.md                    # This file
├── sublime_text/               # Sublime Text package
│   ├── Scrawl.sublime-syntax   # Syntax highlighting rules
│   ├── *.sublime-completions  # Auto-completions
│   ├── *.sublime-snippet       # Code snippets
│   └── README.md               # Sublime Text specific docs
├── vscode/                     # VS Code extension
│   ├── package.json            # Extension manifest
│   ├── language-configuration.json
│   ├── syntaxes/
│   │   └── scrawl.tmLanguage.json
│   └── README.md               # VS Code specific docs
└── tests/                      # Example Scrawl files
    └── test.scrawl
```

## Contributing

Contributions are welcome! Here are some ways you can help:

1. **Report Issues**: Found a bug or have a feature request? Open an issue!
2. **Improve Syntax**: Enhance the syntax highlighting rules
3. **Add Snippets**: Create useful code snippets and completions
4. **Documentation**: Help improve documentation and examples
5. **Editor Support**: Add support for other editors (Vim, Emacs, etc.)

### Development Setup

1. Fork this repository
2. Make your changes in the appropriate directory (`sublime_text/` or `vscode/`)
3. Test your changes with the files in `tests/`
4. Submit a pull request

## Customization

Both editor packages can be customized:

- **Sublime Text**: Modify `.sublime-syntax`, `.sublime-color-scheme`, and other configuration files
- **VS Code**: Edit `scrawl.tmLanguage.json` and `language-configuration.json`

## License

This project is open source and available under the MIT License.

## Changelog

### v0.1.0
- Initial release
- Basic syntax highlighting for both Sublime Text and VS Code
- Support for headers, tags, comments, and code blocks
- Auto-completion and snippets
- URL highlighting

---

**Happy note-taking with Scrawl! 📝✨** 