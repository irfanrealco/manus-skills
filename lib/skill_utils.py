"""Shared utilities for all Manus skills"""

import os
import json
import shutil
from pathlib import Path
from typing import Dict, List, Optional
from datetime import datetime

class SkillUtils:
    """Common utilities for skill operations"""
    
    @staticmethod
    def validate_skill_structure(skill_path: str) -> Dict:
        """Validate skill has required structure
        
        Returns dict with validation results:
        {
            "valid": bool,
            "missing": List[str],
            "warnings": List[str]
        }
        """
        path = Path(skill_path)
        required = {
            "SKILL.md": path / "SKILL.md",
            "scripts/": path / "scripts",
            "templates/": path / "templates",
            "references/": path / "references"
        }
        
        missing = []
        for name, item_path in required.items():
            if not item_path.exists():
                missing.append(name)
        
        return {
            "valid": len(missing) == 0,
            "missing": missing,
            "warnings": []
        }
    
    @staticmethod
    def render_template(template_path: str, variables: Dict) -> str:
        """Render template with variables
        
        Simple variable substitution: {{var_name}}
        """
        content = Path(template_path).read_text()
        
        for key, value in variables.items():
            placeholder = f"{{{{{key}}}}}"
            content = content.replace(placeholder, str(value))
        
        return content
    
    @staticmethod
    def render_template_string(template: str, variables: Dict) -> str:
        """Render template string with variables
        
        Simple variable substitution: {{var_name}}
        """
        content = template
        
        for key, value in variables.items():
            placeholder = f"{{{{{key}}}}}"
            content = content.replace(placeholder, str(value))
        
        return content
    
    @staticmethod
    def save_with_backup(file_path: str, content: str):
        """Save file with automatic backup"""
        path = Path(file_path)
        
        # Create backup if file exists
        if path.exists():
            backup_path = path.with_suffix(path.suffix + ".bak")
            shutil.copy2(path, backup_path)
        
        # Save new content
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content)
    
    @staticmethod
    def log_skill_usage(skill_name: str, context: Dict, log_dir: str = "/tmp/skill-logs"):
        """Log skill usage for analytics"""
        log_path = Path(log_dir)
        log_path.mkdir(parents=True, exist_ok=True)
        
        log_entry = {
            "timestamp": datetime.now().isoformat(),
            "skill": skill_name,
            "context": context
        }
        
        log_file = log_path / f"{datetime.now().strftime('%Y-%m-%d')}.jsonl"
        with open(log_file, "a") as f:
            f.write(json.dumps(log_entry) + "\n")
