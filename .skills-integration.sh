# Skill Arsenal Integration
# Auto-loaded in every terminal

export SKILLS_DIR="$HOME/skills"
export SKILLS_PATH="$SKILLS_DIR/skills"

# Skill command - view a skill
skill() {
    if [ -z "$1" ]; then
        echo "Usage: skill <skill-name>"
        echo "Example: skill systematic-debugging"
        echo ""
        echo "Available skills:"
        ls "$SKILLS_PATH"
        return 1
    fi
    
    local skill_name="$1"
    local skill_file=""
    
    # Search for the skill in all categories
    skill_file=$(find "$SKILLS_PATH" -type f -name "SKILL.md" -path "*/$skill_name/SKILL.md" | head -1)
    
    if [ -z "$skill_file" ]; then
        echo "❌ Skill '$skill_name' not found"
        echo ""
        echo "Try: skills-list"
        return 1
    fi
    
    echo "📖 Viewing skill: $skill_name"
    echo "========================================"
    cat "$skill_file"
}

# List all skills
skills-list() {
    echo "🎯 Your Skill Arsenal (71 skills)"
    echo "========================================"
    echo ""
    
    for category in "$SKILLS_PATH"/*; do
        if [ -d "$category" ]; then
            category_name=$(basename "$category")
            echo "📁 $category_name:"
            for skill_dir in "$category"/*; do
                if [ -d "$skill_dir" ] && [ -f "$skill_dir/SKILL.md" ]; then
                    skill_name=$(basename "$skill_dir")
                    echo "   - $skill_name"
                fi
            done
            echo ""
        fi
    done
}

# Search skills by keyword
skills-search() {
    if [ -z "$1" ]; then
        echo "Usage: skills-search <keyword>"
        return 1
    fi
    
    echo "🔍 Searching for: $1"
    echo "========================================"
    find "$SKILLS_PATH" -name "SKILL.md" -type f -exec grep -l -i "$1" {} \; | while read -r skill_path; do
        skill_name=$(dirname "$skill_path" | xargs basename)
        echo "✓ $skill_name"
    done
}

# Get skill path
skills-path() {
    if [ -z "$1" ]; then
        echo "$SKILLS_PATH"
        return 0
    fi
    
    local skill_name="$1"
    local skill_dir=""
    
    skill_dir=$(find "$SKILLS_PATH" -type d -name "$skill_name" | head -1)
    
    if [ -z "$skill_dir" ]; then
        echo "❌ Skill '$skill_name' not found"
        return 1
    fi
    
    echo "$skill_dir"
}

# Update skills from GitHub
skills-update() {
    echo "📥 Updating skills from GitHub..."
    cd "$SKILLS_DIR"
    git pull origin main
    echo "✅ Skills updated!"
}

# Show skill stats
skills-stats() {
    echo "📊 Skill Arsenal Statistics"
    echo "========================================"
    echo ""
    
    local total_skills=0
    
    for category in "$SKILLS_PATH"/*; do
        if [ -d "$category" ]; then
            category_name=$(basename "$category")
            count=$(find "$category" -name "SKILL.md" | wc -l)
            total_skills=$((total_skills + count))
            echo "📁 $category_name: $count skills"
        fi
    done
    
    echo ""
    echo "🎯 Total: $total_skills skills"
}

# Quick access aliases
alias sk='skill'
alias skl='skills-list'
alias sks='skills-search'
alias sku='skills-update'
alias skst='skills-stats'
alias skp='skills-path'

