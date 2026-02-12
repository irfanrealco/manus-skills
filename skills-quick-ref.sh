#!/bin/bash
# Skills Quick Reference - All 71 Skills at Your Fingertips
# Usage: skills-menu or just 'sm'

skills-menu() {
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                        🎯 YOUR 71-SKILL ARSENAL                              ║
║                     Type: /skill-name (in Manus chat)                        ║
║                     Type: skill skill-name (in terminal)                     ║
╚══════════════════════════════════════════════════════════════════════════════╝

📊 ANALYSIS SKILLS (6)
  /get-to-know-a-client          Deep client analysis + product design
  /investigate-before-recommend  Investigate before recommending
  /production-system-audit       Comprehensive system audits
  /similarweb-analytics          Website traffic analytics
  /stock-analysis                Stock & company analysis
  /system-architect              Design complex systems

🤖 AUTOMATION SKILLS (5)
  /autonomous-github-sync        Auto-commit to GitHub via Google Drive
  /autonomous-sync-script        One-command GitHub sync
  /github-gem-seeker             Find open source solutions
  /organize-github-repos         Audit GitHub/Supabase alignment
  /using-git-worktrees           Git worktree management

🎨 DESIGN SKILLS (8)
  /brainstorm-logos              Strategic logo brainstorming
  /brand-driven-ux-overhaul      Brand-driven UX redesign
  /canvas-design                 Canvas-based design
  /excel-generator               Professional spreadsheets
  /frontend-design               Frontend UI/UX design
  /inspirational-music-video-production  Music videos
  /theme-factory                 Theme generation
  /video-generator               AI video production

💻 DEVELOPMENT SKILLS (5)
  /multiplayer-game-builder      Multiplayer turn-based games
  /promo-code-system             Promo/discount codes
  /realistic-ai-persona-builder  Challenging AI personas
  /role-based-access-control     RBAC implementation
  /vertical-expansion-blueprint  Vertical industry adaptation

🔌 INTEGRATION SKILLS (6)
  /manus-mcp-configurator        MCP server configuration
  /mcp-auto-recovery             MCP connection recovery
  /mcp-builder                   Build MCP servers
  /mcp-connector-tester          Test MCP connectors
  /mcp-ecosystem-optimizer       MCP infrastructure optimization
  /voice-ai-integration          Voice AI platforms (Hume EVI)

🏗️ FOUNDATION SKILLS - TIER 1 (3)
  /api-endpoint-builder          API endpoints
  /database-schema-generator     Database schemas
  /testing-framework             Test framework setup

🏗️ FOUNDATION SKILLS - TIER 2 (3)
  /deployment-automation         CI/CD pipelines
  /error-monitoring-setup        Error tracking
  /github-workflow-automation    GitHub Actions

🏗️ FOUNDATION SKILLS - TIER 3 (4)
  /analytics-dashboard           Analytics dashboards
  /email-system-builder          Email systems
  /feature-flag-system           Feature flags
  /user-authentication-system    User authentication

🏗️ FOUNDATION SKILLS - TIER 4 (5)
  /cron-job-scheduler            Cron jobs
  /file-upload-system            File uploads
  /notification-system           Notifications
  /payment-integration           Payment processing
  /search-implementation         Search functionality

🛠️ UTILITY SKILLS (12)
  /debug-mining-engine           Transform bugs into skills
  /doc-coauthoring               Collaborative documents
  /docx                          Word document manipulation
  /internet-skill-finder         Find skills online
  /pdf                           PDF generation & manipulation
  /pptx                          PowerPoint creation
  /project-handoff-ingestion     Project handoffs
  /serverless-debugging          Edge function debugging
  /skill-creator                 Create new skills
  /skill-demo-builder            Create skill demos
  /skill-development-workflow    Skill creation automation
  /xlsx                          Excel manipulation

🔄 WORKFLOW SKILLS (14)
  /brainstorming                 🔥 ALWAYS use before building!
  /dispatching-parallel-agents   Multi-agent coordination
  /executing-plans               Plan execution
  /feature-verification          Multi-layer testing
  /finishing-a-development-branch Branch completion
  /receiving-code-review         Code review response
  /requesting-code-review        Code review requests
  /subagent-driven-development   Phase-based development
  /systematic-debugging          🔥 Systematic debugging
  /systematic-feature-builder    Organized feature development
  /test-driven-development       TDD workflow
  /verification-before-completion Final verification
  /writing-plans                 Plan creation

╔══════════════════════════════════════════════════════════════════════════════╗
║  QUICK COMMANDS                                                              ║
║  sm              Show this menu                                              ║
║  skills-list     List all skills (detailed)                                  ║
║  skills-search   Search skills by keyword                                    ║
║  skills-stats    Show statistics                                             ║
║  skill <name>    View a skill's documentation                                ║
╚══════════════════════════════════════════════════════════════════════════════╝

🔥 MOST USED:
  /brainstorming  /systematic-debugging  /debug-mining-engine  /skill-creator

EOF
}

# Compact version - just names
skills-compact() {
    cat << 'EOF'
🎯 71 SKILLS - QUICK LIST

📊 ANALYSIS (6): get-to-know-a-client, investigate-before-recommend, 
   production-system-audit, similarweb-analytics, stock-analysis, system-architect

🤖 AUTOMATION (5): autonomous-github-sync, autonomous-sync-script, github-gem-seeker,
   organize-github-repos, using-git-worktrees

🎨 DESIGN (8): brainstorm-logos, brand-driven-ux-overhaul, canvas-design, 
   excel-generator, frontend-design, inspirational-music-video-production,
   theme-factory, video-generator

💻 DEVELOPMENT (5): multiplayer-game-builder, promo-code-system, 
   realistic-ai-persona-builder, role-based-access-control, vertical-expansion-blueprint

🔌 INTEGRATION (6): manus-mcp-configurator, mcp-auto-recovery, mcp-builder,
   mcp-connector-tester, mcp-ecosystem-optimizer, voice-ai-integration

🏗️ FOUNDATION T1-4 (15): api-endpoint-builder, database-schema-generator, 
   testing-framework, deployment-automation, error-monitoring-setup,
   github-workflow-automation, analytics-dashboard, email-system-builder,
   feature-flag-system, user-authentication-system, cron-job-scheduler,
   file-upload-system, notification-system, payment-integration, search-implementation

🛠️ UTILITY (12): debug-mining-engine, doc-coauthoring, docx, internet-skill-finder,
   pdf, pptx, project-handoff-ingestion, serverless-debugging, skill-creator,
   skill-demo-builder, skill-development-workflow, xlsx

🔄 WORKFLOW (14): brainstorming, dispatching-parallel-agents, executing-plans,
   feature-verification, finishing-a-development-branch, receiving-code-review,
   requesting-code-review, subagent-driven-development, systematic-debugging,
   systematic-feature-builder, test-driven-development, 
   verification-before-completion, writing-plans

Type: sm (full menu) | skills-search <keyword> | skill <name>
EOF
}

# Category-specific views
skills-by-category() {
    local category="$1"
    case "$category" in
        analysis|📊)
            echo "📊 ANALYSIS SKILLS:"
            echo "  /get-to-know-a-client /investigate-before-recommend"
            echo "  /production-system-audit /similarweb-analytics"
            echo "  /stock-analysis /system-architect"
            ;;
        automation|🤖)
            echo "🤖 AUTOMATION SKILLS:"
            echo "  /autonomous-github-sync /autonomous-sync-script"
            echo "  /github-gem-seeker /organize-github-repos /using-git-worktrees"
            ;;
        design|🎨)
            echo "🎨 DESIGN SKILLS:"
            echo "  /brainstorm-logos /brand-driven-ux-overhaul /canvas-design"
            echo "  /excel-generator /frontend-design"
            echo "  /inspirational-music-video-production /theme-factory /video-generator"
            ;;
        dev|development|💻)
            echo "💻 DEVELOPMENT SKILLS:"
            echo "  /multiplayer-game-builder /promo-code-system"
            echo "  /realistic-ai-persona-builder /role-based-access-control"
            echo "  /vertical-expansion-blueprint"
            ;;
        integration|🔌)
            echo "🔌 INTEGRATION SKILLS:"
            echo "  /manus-mcp-configurator /mcp-auto-recovery /mcp-builder"
            echo "  /mcp-connector-tester /mcp-ecosystem-optimizer /voice-ai-integration"
            ;;
        foundation|🏗️)
            echo "🏗️ FOUNDATION SKILLS (15):"
            echo "  T1: /api-endpoint-builder /database-schema-generator /testing-framework"
            echo "  T2: /deployment-automation /error-monitoring-setup /github-workflow-automation"
            echo "  T3: /analytics-dashboard /email-system-builder /feature-flag-system"
            echo "      /user-authentication-system"
            echo "  T4: /cron-job-scheduler /file-upload-system /notification-system"
            echo "      /payment-integration /search-implementation"
            ;;
        utility|🛠️)
            echo "🛠️ UTILITY SKILLS:"
            echo "  /debug-mining-engine /doc-coauthoring /docx /internet-skill-finder"
            echo "  /pdf /pptx /project-handoff-ingestion /serverless-debugging"
            echo "  /skill-creator /skill-demo-builder /skill-development-workflow /xlsx"
            ;;
        workflow|🔄)
            echo "🔄 WORKFLOW SKILLS:"
            echo "  /brainstorming 🔥 /systematic-debugging 🔥"
            echo "  /dispatching-parallel-agents /executing-plans /feature-verification"
            echo "  /finishing-a-development-branch /receiving-code-review"
            echo "  /requesting-code-review /subagent-driven-development"
            echo "  /systematic-feature-builder /test-driven-development"
            echo "  /verification-before-completion /writing-plans"
            ;;
        *)
            echo "Usage: skills-by-category <category>"
            echo "Categories: analysis, automation, design, development, integration, foundation, utility, workflow"
            ;;
    esac
}

# Aliases
alias sm='skills-menu'
alias sc='skills-compact'
alias sbc='skills-by-category'

# Export functions
export -f skills-menu
export -f skills-compact
export -f skills-by-category
