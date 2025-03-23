# Scrawl Language Support for VS Code

This extension provides syntax highlighting for Scrawl, a note-taking format with enhanced code block support.

## Features

- Syntax highlighting for:
  - Header blocks
  - Section folding with the `##SectionName##` syntax
  - URLs
  - Code blocks for multiple languages including:
    - TypeScript/JavaScript
    - Python
    - Ruby
    - C/C++/C#
    - Java
    - HTML/CSS
    - PHP
    - Go
    - Rust
    - Bash/Shell
    - SQL
    - JSON
    - XML
    - YAML
    - Markdown
  - Line comments with `//`
  - Block comments with `/* */`

## Installation

### Manual Installation

1. Create a folder in your VS Code extensions directory:
   - **Windows**: `%USERPROFILE%\.vscode\extensions\scrawl-language`
   - **macOS/Linux**: `~/.vscode/extensions/scrawl-language`

2. Place the following files in this folder:
   - `package.json`
   - `language-configuration.json`
   - Create a `syntaxes` folder and place `scrawl.tmLanguage.json` inside it

3. Restart VS Code

### Building as a VSIX Package

1. Install Node.js and npm if you haven't already
2. Install the VS Code Extension Manager:
   ```
   npm install -g @vscode/vsce
   ```
3. From the root of the extension folder, run:
   ```
   vsce package
   ```
4. Install the generated `.vsix` file using:
   ```
   code --install-extension scrawl-language-0.1.0.vsix
   ```
   (Replace the version number as needed)

## Usage

Files with the extensions `.scrawl` or `.note` will automatically use this syntax highlighting.

## Example

```scrawl
/*
*--------------------------
* /////////////////////
* 10/15/2023 Wednesday
* /////////////////////
*--------------------------
*/

##Notes Section##

Here are some notes with a URL: https://example.com

// This is a comment

Here is some code:

```python
def hello_world():
    print("Hello, world!")
```

##End##
```