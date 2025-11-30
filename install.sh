#!/bin/bash

# Scrawl Language Support - Installation Script
# This script creates symlinks for Sublime Text, VS Code, and Cursor

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
# VS Code
# ============================================
echo -e "${BLUE}VS Code${NC}"
VSCODE_EXTENSIONS="$HOME/.vscode/extensions"

if [ -d "$VSCODE_EXTENSIONS" ]; then
    create_symlink "$SCRIPT_DIR/vscode" "$VSCODE_EXTENSIONS/scrawl" "VS Code"
    ((installed++)) || true
else
    echo -e "${YELLOW}!${NC} VS Code: Extensions folder not found"
    echo -e "   Expected: $VSCODE_EXTENSIONS"
    echo -e "   Is VS Code installed?"
    ((skipped++)) || true
fi

echo ""

# ============================================
# Cursor
# ============================================
echo -e "${BLUE}Cursor${NC}"
CURSOR_EXTENSIONS="$HOME/.cursor/extensions"

if [ -d "$CURSOR_EXTENSIONS" ]; then
    create_symlink "$SCRIPT_DIR/vscode" "$CURSOR_EXTENSIONS/scrawl" "Cursor"
    ((installed++)) || true
else
    echo -e "${YELLOW}!${NC} Cursor: Extensions folder not found"
    echo -e "   Expected: $CURSOR_EXTENSIONS"
    echo -e "   Is Cursor installed?"
    ((skipped++)) || true
fi

echo ""

# ============================================
# Summary
# ============================================
echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}  Installation Complete          ${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""
echo -e "To activate the syntax highlighting:"
echo -e "  ${YELLOW}Sublime Text:${NC} Tools > Developer > Reload Syntax Definitions"
echo -e "  ${YELLOW}VS Code:${NC} Cmd+Shift+P > Developer: Reload Window"
echo -e "  ${YELLOW}Cursor:${NC} Cmd+Shift+P > Developer: Reload Window"
echo ""
echo -e "Test files are available at:"
echo -e "  - tests/test.scrawl"
echo -e "  - docs/FEATURE_TEST.scrawl"
echo ""
