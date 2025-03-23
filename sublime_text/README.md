# Scrawl - Sublime Text Note-Taking Package

Scrawl is a specialized Sublime Text package that enhances your note-taking experience by providing syntax highlighting and snippets for a custom note format. It's designed to make note-taking more structured and visually organized within the Sublime Text editor.

## Features

- **Custom Syntax Highlighting**: Special highlighting for Scrawl files (`.scrawl` and `.note` extensions)
- **Structured Note Format**: Supports a custom note-taking format with:
  - Header blocks with date formatting
  - Tag system (using `##tag##` syntax)
  - URL highlighting
  - Comment support (both line and block comments)
- **Snippets**: Quick insertion of common elements:
  - Note headers
  - Tags
  - Other common note-taking elements

## Installation

1. Clone this repository into your Sublime Text packages directory:
   ```
   ~/Library/Application Support/Sublime Text/Packages/
   ```
2. Restart Sublime Text

## Usage

### File Extensions
Scrawl supports two file extensions:
- `.scrawl`
- `.note`

### Note Header Format
Use the note header snippet to create a formatted header block:
```
/*
 *--------*
 * 3/22/24 *
 *--------*
 */
```

### Tags
Use the tag snippet or manually type tags in the following format:
```
##tag-name##
```

### Comments
Scrawl supports both single-line and block comments:
```
// Single line comment
/* Block comment
   spanning multiple lines */
```

### URLs
URLs are automatically highlighted in your notes:
```
https://example.com
```

## Snippets

### Note Header
Trigger: `note-header`
Creates a formatted header block with the current date.

### Tag
Trigger: `tag`
Inserts a tag template: `##tag-name##`

## Customization

The package includes:
- `Scrawl.sublime-syntax`: Syntax highlighting rules
- `Scrawl.sublime-color-scheme`: Color scheme definitions
- `Scrawl.tmPreferences`: TextMate preferences

You can customize these files to match your preferred style and needs.

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the MIT License. 