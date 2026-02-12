"""Validate skill quality and standards"""

from pathlib import Path
from typing import Dict, List

class SkillValidator:
    """Validate skills meet quality standards"""
    
    def validate_documentation(self, skill_path: str) -> Dict:
        """Check SKILL.md completeness"""
        path = Path(skill_path)
        skill_md = path / "SKILL.md"
        
        result = {
            "valid": False,
            "issues": [],
            "score": 0
        }
        
        if not skill_md.exists():
            result["issues"].append("SKILL.md not found")
            return result
        
        content = skill_md.read_text()
        
        # Check for required sections
        required_sections = ["Overview", "Workflow", "Usage"]
        for section in required_sections:
            if section.lower() in content.lower():
                result["score"] += 1
        
        # Check for frontmatter
        if content.startswith("---"):
            result["score"] += 1
        
        result["valid"] = result["score"] >= 3
        return result
    
    def validate_scripts(self, skill_path: str) -> Dict:
        """Check scripts are executable and documented"""
        path = Path(skill_path)
        scripts_dir = path / "scripts"
        
        result = {
            "valid": False,
            "scripts": [],
            "issues": []
        }
        
        if not scripts_dir.exists():
            result["issues"].append("scripts/ directory not found")
            return result
        
        scripts = list(scripts_dir.glob("*.py"))
        
        for script in scripts:
            script_info = {
                "name": script.name,
                "executable": script.stat().st_mode & 0o111 != 0,
                "has_docstring": False
            }
            
            # Check for docstring
            content = script.read_text()
            if '"""' in content or "'''" in content:
                script_info["has_docstring"] = True
            
            result["scripts"].append(script_info)
        
        result["valid"] = len(scripts) > 0
        return result
    
    def validate_templates(self, skill_path: str) -> Dict:
        """Check templates are valid"""
        path = Path(skill_path)
        templates_dir = path / "templates"
        
        result = {
            "valid": False,
            "templates": [],
            "issues": []
        }
        
        if not templates_dir.exists():
            result["issues"].append("templates/ directory not found")
            return result
        
        templates = list(templates_dir.glob("*"))
        result["templates"] = [t.name for t in templates if t.is_file()]
        result["valid"] = len(result["templates"]) > 0
        
        return result
    
    def generate_quality_report(self, skill_path: str) -> str:
        """Generate comprehensive quality report"""
        path = Path(skill_path)
        skill_name = path.name
        
        doc_result = self.validate_documentation(skill_path)
        script_result = self.validate_scripts(skill_path)
        template_result = self.validate_templates(skill_path)
        
        total_score = (
            doc_result["score"] +
            (5 if script_result["valid"] else 0) +
            (3 if template_result["valid"] else 0)
        )
        
        report = [
            f"# Quality Report: {skill_name}",
            "",
            f"**Total Score:** {total_score}/12",
            "",
            "## Documentation",
            f"- Valid: {doc_result['valid']}",
            f"- Score: {doc_result['score']}/4",
            f"- Issues: {', '.join(doc_result['issues']) if doc_result['issues'] else 'None'}",
            "",
            "## Scripts",
            f"- Valid: {script_result['valid']}",
            f"- Count: {len(script_result['scripts'])}",
            "",
            "## Templates",
            f"- Valid: {template_result['valid']}",
            f"- Count: {len(template_result['templates'])}",
            ""
        ]
        
        return "\n".join(report)
