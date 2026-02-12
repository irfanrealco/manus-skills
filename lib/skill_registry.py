"""Skill discovery and registry management"""

import json
from pathlib import Path
from typing import Dict, List, Optional

class SkillRegistry:
    """Manage skill registry and discovery"""
    
    def __init__(self, registry_path: str = "/tmp/manus-skills-v2/skills.json"):
        self.registry_path = Path(registry_path)
        self.registry = self._load_registry()
    
    def _load_registry(self) -> Dict:
        """Load skills.json registry"""
        if not self.registry_path.exists():
            return {
                "version": "1.0.0",
                "skills": {},
                "categories": {},
                "meta_skills": {},
                "dependency_graph": {}
            }
        
        with open(self.registry_path) as f:
            return json.load(f)
    
    def find_by_tag(self, tag: str) -> List[Dict]:
        """Find skills by tag"""
        results = []
        
        for skill_name, skill_data in self.registry["skills"].items():
            if tag.lower() in [t.lower() for t in skill_data.get("tags", [])]:
                results.append(skill_data)
        
        return results
    
    def find_by_category(self, category: str) -> List[str]:
        """Find skills in a category"""
        return self.registry["categories"].get(category, [])
    
    def get_skill(self, skill_name: str) -> Optional[Dict]:
        """Get skill metadata"""
        return self.registry["skills"].get(skill_name)
    
    def get_complements(self, skill_name: str) -> List[str]:
        """Get complementary skills"""
        skill = self.get_skill(skill_name)
        if not skill:
            return []
        return skill.get("complements", [])
    
    def get_dependencies(self, skill_name: str) -> Dict:
        """Get skill dependencies (before/after)"""
        return self.registry["dependency_graph"].get(skill_name, {
            "before": [],
            "after": []
        })
    
    def suggest_workflow(self, goal: str) -> List[str]:
        """Suggest skill workflow for a goal
        
        Simple keyword-based matching for now
        Can be enhanced with AI later
        """
        goal_lower = goal.lower()
        suggested = []
        
        # Common patterns
        if "saas" in goal_lower or "full" in goal_lower and "app" in goal_lower:
            suggested = [
                "brainstorming",
                "database-schema-generator",
                "api-endpoint-builder",
                "user-authentication-system",
                "frontend-design",
                "testing-framework",
                "deployment-automation"
            ]
        elif "api" in goal_lower:
            suggested = [
                "database-schema-generator",
                "api-endpoint-builder",
                "testing-framework",
                "deployment-automation"
            ]
        elif "frontend" in goal_lower or "ui" in goal_lower:
            suggested = [
                "frontend-design",
                "theme-factory",
                "testing-framework"
            ]
        elif "database" in goal_lower or "schema" in goal_lower:
            suggested = [
                "database-schema-generator",
                "testing-framework"
            ]
        
        return suggested
    
    def get_all_categories(self) -> List[str]:
        """Get list of all categories"""
        return list(self.registry["categories"].keys())
    
    def get_stats(self) -> Dict:
        """Get registry statistics"""
        return {
            "total_skills": self.registry.get("total_skills", 0),
            "categories": len(self.registry["categories"]),
            "meta_skills": len(self.registry["meta_skills"])
        }
