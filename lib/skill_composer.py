"""Compose multiple skills into workflows"""

from typing import Dict, List
from .skill_registry import SkillRegistry

class SkillComposer:
    """Chain and orchestrate multiple skills"""
    
    def __init__(self, registry: SkillRegistry):
        self.registry = registry
    
    def compose_workflow(self, skill_names: List[str]) -> Dict:
        """Create workflow from skill list
        
        Returns workflow dict with:
        - skills: List of skill metadata
        - dependencies: Resolved dependency order
        - valid: Whether workflow is valid
        """
        workflow = {
            "skills": [],
            "dependencies": [],
            "valid": True,
            "errors": []
        }
        
        # Collect skill metadata
        for skill_name in skill_names:
            skill = self.registry.get_skill(skill_name)
            if not skill:
                workflow["valid"] = False
                workflow["errors"].append(f"Skill not found: {skill_name}")
            else:
                workflow["skills"].append(skill)
        
        # Resolve dependencies (simple topological sort)
        workflow["dependencies"] = self._resolve_dependencies(skill_names)
        
        return workflow
    
    def _resolve_dependencies(self, skill_names: List[str]) -> List[str]:
        """Resolve dependency order for skills
        
        Simple approach: maintain order but ensure dependencies come first
        """
        ordered = []
        remaining = list(skill_names)
        
        while remaining:
            added_any = False
            
            for skill_name in remaining[:]:
                deps = self.registry.get_dependencies(skill_name)
                before_deps = deps.get("before", [])
                
                # Check if all dependencies are satisfied
                if all(dep in ordered or dep not in skill_names for dep in before_deps):
                    ordered.append(skill_name)
                    remaining.remove(skill_name)
                    added_any = True
            
            # Prevent infinite loop
            if not added_any and remaining:
                ordered.extend(remaining)
                break
        
        return ordered
    
    def validate_workflow(self, workflow: Dict) -> bool:
        """Validate workflow dependencies"""
        return workflow.get("valid", False)
    
    def execute_workflow(self, workflow: Dict, context: Dict) -> Dict:
        """Execute a skill workflow
        
        This is a placeholder - actual execution would invoke skill scripts
        """
        results = {
            "executed": [],
            "context": context,
            "success": True
        }
        
        for skill in workflow["skills"]:
            # Placeholder: would actually run skill scripts here
            results["executed"].append(skill["name"])
        
        return results
