#!/bin/bash
# Enable automatic hourly skill updates for Manus terminals
# This script sets up a cron job to pull skill updates every hour

set -e

SKILLS_DIR="$HOME/skills"
LOG_FILE="$HOME/.skills-update.log"
CRON_COMMENT="# Manus Skills Auto-Update (runs hourly)"
CRON_JOB="0 * * * * cd $SKILLS_DIR && git pull --quiet --ff-only origin main >> $LOG_FILE 2>&1"

echo "🔧 Setting up automatic hourly skill updates..."
echo ""

# Check if skills directory exists
if [ ! -d "$SKILLS_DIR" ]; then
    echo "❌ Skills directory not found at $SKILLS_DIR"
    echo ""
    echo "Please install manus-skills first:"
    echo "  curl -sSL https://raw.githubusercontent.com/abcnuts/manus-skills/main/auto-install-skills.sh | bash"
    exit 1
fi

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "cd $SKILLS_DIR && git pull"; then
    echo "✅ Auto-update is already enabled!"
    echo ""
    echo "📊 Status:"
    echo "   Cron job: Active"
    echo "   Update frequency: Every hour (at :00)"
    echo "   Log file: $LOG_FILE"
    echo ""
    echo "📋 View recent updates:"
    echo "   tail -20 $LOG_FILE"
    exit 0
fi

# Create log file if it doesn't exist
touch "$LOG_FILE"

# Add cron job
echo "📝 Adding cron job..."
(crontab -l 2>/dev/null; echo ""; echo "$CRON_COMMENT"; echo "$CRON_JOB") | crontab -

echo "✅ Automatic hourly skill updates enabled!"
echo ""
echo "📊 Configuration:"
echo "   Update frequency: Every hour (at :00)"
echo "   Skills directory: $SKILLS_DIR"
echo "   Log file: $LOG_FILE"
echo ""
echo "🔍 Verify installation:"
echo "   crontab -l | grep skills"
echo ""
echo "📋 View update log:"
echo "   tail -20 $LOG_FILE"
echo ""
echo "💡 Next update will run at the top of the next hour"
echo "   (You can also manually update anytime with: skills-update)"
