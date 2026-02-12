#!/bin/bash
# Auto-Install Skills - Silent Background Installation
# This script automatically installs skills if not already present

# Silent mode - no output unless there's an error
SILENT=true

log() {
    if [ "$SILENT" != "true" ]; then
        echo "$1"
    fi
}

# Check if skills are already installed
if [ -d "$HOME/skills" ] && [ -f "$HOME/.skills-integration.sh" ]; then
    log "✅ Skills already installed"
    source "$HOME/.skills-integration.sh" 2>/dev/null
    exit 0
fi

# Install skills silently
log "📦 Installing skills..."

# Configuration
SKILLS_DIR="$HOME/skills"
SKILLS_REPO="https://github.com/abcnuts/manus-skills.git"
SHELL_RC="$HOME/.bashrc"

# Clone repository (silently)
if [ ! -d "$SKILLS_DIR" ]; then
    git clone --quiet "$SKILLS_REPO" "$SKILLS_DIR" 2>/dev/null || {
        echo "❌ Failed to clone skills repository"
        exit 1
    }
fi

# Download quick reference
if [ -f "$SKILLS_DIR/skills-quick-ref.sh" ]; then
    cp "$SKILLS_DIR/skills-quick-ref.sh" "$HOME/skills-quick-ref.sh"
    chmod +x "$HOME/skills-quick-ref.sh"
fi

# Create integration script
cat > "$HOME/.skills-integration.sh" << 'EOF'
# Skill Arsenal Integration - Auto-loaded
export SKILLS_DIR="$HOME/skills"
export SKILLS_PATH="$SKILLS_DIR/skills"

skill() {
    if [ -z "$1" ]; then
        echo "Usage: skill <skill-name>"
        return 1
    fi
    local skill_file=$(find "$SKILLS_PATH" -type f -name "SKILL.md" -path "*/$1/SKILL.md" | head -1)
    if [ -z "$skill_file" ]; then
        echo "❌ Skill '$1' not found"
        return 1
    fi
    cat "$skill_file"
}

skills-list() {
    echo "🎯 Your Skill Arsenal"
    echo "========================================"
    for category in "$SKILLS_PATH"/*; do
        if [ -d "$category" ]; then
            echo "📁 $(basename "$category"):"
            for skill_dir in "$category"/*; do
                if [ -d "$skill_dir" ] && [ -f "$skill_dir/SKILL.md" ]; then
                    echo "   - $(basename "$skill_dir")"
                fi
            done
        fi
    done
}

skills-search() {
    if [ -z "$1" ]; then
        echo "Usage: skills-search <keyword>"
        return 1
    fi
    find "$SKILLS_PATH" -name "SKILL.md" -type f -exec grep -l -i "$1" {} \; | while read -r skill_path; do
        echo "✓ $(dirname "$skill_path" | xargs basename)"
    done
}

skills-path() {
    if [ -z "$1" ]; then
        echo "$SKILLS_PATH"
        return 0
    fi
    local skill_dir=$(find "$SKILLS_PATH" -type d -name "$1" | head -1)
    if [ -z "$skill_dir" ]; then
        echo "❌ Skill '$1' not found"
        return 1
    fi
    echo "$skill_dir"
}

skills-update() {
    cd "$SKILLS_DIR" && git pull --quiet origin main
    echo "✅ Skills updated!"
}

skills-stats() {
    echo "📊 Skill Arsenal Statistics"
    echo "========================================"
    local total=0
    for category in "$SKILLS_PATH"/*; do
        if [ -d "$category" ]; then
            local count=$(find "$category" -name "SKILL.md" | wc -l)
            total=$((total + count))
            echo "📁 $(basename "$category"): $count skills"
        fi
    done
    echo ""
    echo "🎯 Total: $total skills"
}

alias sk='skill'
alias skl='skills-list'
alias sks='skills-search'
alias sku='skills-update'
alias skst='skills-stats'
alias skp='skills-path'

# Quick Reference Menu
source "$HOME/skills-quick-ref.sh" 2>/dev/null || true
EOF

# Add to bashrc if not present
if ! grep -q ".skills-integration.sh" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# Skill Arsenal Auto-Integration" >> "$SHELL_RC"
    echo "if [ -f ~/.skills-integration.sh ]; then" >> "$SHELL_RC"
    echo "    source ~/.skills-integration.sh 2>/dev/null" >> "$SHELL_RC"
    echo "fi" >> "$SHELL_RC"
fi

# Source it for current session
source "$HOME/.skills-integration.sh" 2>/dev/null

log "✅ Skills installed and ready!"
