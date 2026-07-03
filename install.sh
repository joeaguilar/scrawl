#!/bin/bash

# Scrawl Language Support - Installation Script
# Creates symlinks for Sublime Text and every detected VS Code-compatible
# editor (VS Code, Insiders, VSCodium, Cursor, Windsurf, Trae, Kiro, ...).
# All VS Code forks share the same extension format, so the one vscode/
# folder serves them all - each editor just needs a symlink in its own
# extensions directory.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}  Scrawl Language Support Setup  ${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"

    if [ -L "$target" ]; then
        # Symlink already exists - normalize paths (remove trailing slashes)
        local current_target=$(readlink "$target" | sed 's:/*$::')
        local expected_source=$(echo "$source" | sed 's:/*$::')
        if [ "$current_target" = "$expected_source" ]; then
            echo -e "${GREEN}✓${NC} $name: Already installed (symlink exists)"
            return 0
        else
            echo -e "${YELLOW}!${NC} $name: Symlink exists but points to different location"
            echo -e "   Current: $current_target"
            echo -e "   Expected: $source"
            read -p "   Replace symlink? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm "$target"
                ln -s "$source" "$target"
                echo -e "${GREEN}✓${NC} $name: Symlink updated"
            else
                echo -e "${YELLOW}!${NC} $name: Skipped"
            fi
            return 0
        fi
    elif [ -e "$target" ]; then
        # Regular file/directory exists
        echo -e "${YELLOW}!${NC} $name: Regular file/directory exists at target location"
        echo -e "   Location: $target"
        read -p "   Backup and replace? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            mv "$target" "${target}.backup.$(date +%Y%m%d%H%M%S)"
            ln -s "$source" "$target"
            echo -e "${GREEN}✓${NC} $name: Installed (old version backed up)"
        else
            echo -e "${YELLOW}!${NC} $name: Skipped"
        fi
        return 0
    else
        # Nothing exists, create symlink
        ln -s "$source" "$target"
        echo -e "${GREEN}✓${NC} $name: Installed"
        return 0
    fi
}

# Remove duplicate symlinks that point at our extension under another name.
# Two links to the same folder give the editor two extensions with the same
# ID; VS Code's scanner then marks the ID obsolete and BOTH copies vanish
# from the language picker.
remove_duplicate_links() {
    local ext_dir="$1"
    local name="$2"
    local expected_source
    expected_source="$(echo "$SCRIPT_DIR/vscode" | sed 's:/*$::')"

    local link
    for link in "$ext_dir"/*; do
        [ -L "$link" ] || continue
        [ "$(basename "$link")" = "scrawl" ] && continue
        local link_target
        link_target="$(readlink "$link" | sed 's:/*$::')"
        if [ "$link_target" = "$expected_source" ]; then
            rm "$link"
            echo -e "${YELLOW}!${NC} $name: Removed duplicate symlink $(basename "$link") (same extension ID twice breaks the editor's extension scanner)"
        fi
    done
}

# Track installations
installed=0
skipped=0

# ============================================
# Sublime Text
# ============================================
echo -e "${BLUE}Sublime Text${NC}"
SUBLIME_PACKAGES="$HOME/Library/Application Support/Sublime Text/Packages"

if [ -d "$SUBLIME_PACKAGES" ]; then
    create_symlink "$SCRIPT_DIR/sublime_text" "$SUBLIME_PACKAGES/Scrawl" "Sublime Text"
    ((installed++)) || true
else
    echo -e "${YELLOW}!${NC} Sublime Text: Packages folder not found"
    echo -e "   Expected: $SUBLIME_PACKAGES"
    echo -e "   Is Sublime Text installed?"
    ((skipped++)) || true
fi

echo ""

# ============================================
# VS Code and compatible editors
# One entry per editor: "Display Name|extensions dir"
# ============================================
VSCODE_FAMILY=(
    "VS Code|$HOME/.vscode/extensions"
    "VS Code Insiders|$HOME/.vscode-insiders/extensions"
    "VSCodium|$HOME/.vscode-oss/extensions"
    "Cursor|$HOME/.cursor/extensions"
    "Windsurf|$HOME/.windsurf/extensions"
    "Trae|$HOME/.trae/extensions"
    "Kiro|$HOME/.kiro/extensions"
    "Positron|$HOME/.positron/extensions"
)

for entry in "${VSCODE_FAMILY[@]}"; do
    name="${entry%%|*}"
    ext_dir="${entry##*|}"

    echo -e "${BLUE}${name}${NC}"
    if [ -d "$ext_dir" ]; then
        remove_duplicate_links "$ext_dir" "$name"
        create_symlink "$SCRIPT_DIR/vscode" "$ext_dir/scrawl" "$name"
        ((installed++)) || true
    else
        echo -e "${YELLOW}-${NC} $name: Not installed (no $ext_dir)"
        ((skipped++)) || true
    fi
    echo ""
done

# ============================================
# Summary
# ============================================
echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}  Installation Complete          ${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""
echo -e "To activate the syntax highlighting:"
echo -e "  ${YELLOW}Sublime Text:${NC} Tools > Developer > Reload Syntax Definitions"
echo -e "  ${YELLOW}VS Code family:${NC} fully quit and relaunch the editor"
echo -e "  (a plain 'Reload Window' is enough for grammar edits, but new"
echo -e "   installs and removed duplicates need a full restart to rescan)"
echo ""
echo -e "Test files are available at:"
echo -e "  - tests/test.scrawl"
echo -e "  - tests/test1.scrawl"
echo ""
