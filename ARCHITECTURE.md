# Architecture Documentation

**Manus Skills Unified Arsenal**  
**Version:** 1.0.0  
**Date:** 2026-02-11

---

## Table of Contents

1. [System Overview](#system-overview)
2. [Five-Layer Architecture](#five-layer-architecture)
3. [Core Components](#core-components)
4. [Data Flow](#data-flow)
5. [Skill Structure](#skill-structure)
6. [Discovery System](#discovery-system)
7. [Dependency Resolution](#dependency-resolution)
8. [Meta-Skills](#meta-skills)
9. [Extension Points](#extension-points)

---

## System Overview

The Manus Skills Unified Arsenal is a **self-aware, composable skill system** designed for AI agents. Skills can discover each other, resolve dependencies, and compose into complex workflows.

### Design Principles

1. **Insanely Organized** - Clear categorization and structure
2. **No Shortcuts** - Production-quality code and documentation
3. **Self-Documenting** - Every component explains itself
4. **Composable** - Skills work together seamlessly
5. **Extensible** - Easy to add new skills and capabilities

### Key Innovations

- **Skill Registry** - Central manifest enables discovery
- **Dependency Graph** - Automatic ordering and validation
- **Shared Utilities** - No code duplication
- **Meta-Skills** - High-level orchestration
- **Quality Standards** - Consistent structure and validation

---

## Five-Layer Architecture

```
┌─────────────────────────────────────────────────────────┐
│  LAYER 5: META-SKILLS                                   │
│  Purpose: Orchestrate multiple skills into workflows   │
│  Examples: full-stack-builder, feature-pipeline        │
│  Technology: Python, skill_composer                     │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  LAYER 4: DISCOVERY & DEPENDENCY SYSTEM                 │
│  Purpose: Enable skill discovery and composition        │
│  Components: skills.json, skill_registry, dependency_graph │
│  Technology: JSON, Python                               │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  LAYER 3: INDIVIDUAL SKILLS                             │
│  Purpose: Implement specific capabilities               │
│  Count: 55 skills across 12 categories                  │
│  Technology: Python, Shell, Templates                   │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  LAYER 2: SHARED UTILITIES                              │
│  Purpose: Provide common functionality                  │
│  Modules: skill_utils, skill_registry, skill_composer,  │
│           skill_validator                               │
│  Technology: Python                                     │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  LAYER 1: FOUNDATION                                    │
│  Purpose: Define standards and patterns                 │
│  Components: Skill structure, documentation standards,  │
│              quality metrics                            │
│  Technology: Markdown, Python                           │
└─────────────────────────────────────────────────────────┘
```

---

## Core Components

### 1. Skill Registry (`skills.json`)

Central manifest containing metadata for all skills.

**Structure:**
```json
{
  "version": "1.0.0",
  "total_skills": 55,
  "categories": { ... },
  "skills": { ... },
  "meta_skills": { ... },
  "dependency_graph": { ... }
}
```

**Metadata per skill:**
- Name, description, category
- Tags for discovery
- Dependencies (before/after)
- Complementary skills
- Time saved estimate
- Quality rating
- Status (production/beta/experimental)

### 2. Shared Utilities (`lib/`)

**skill_utils.py** - Common operations
- `validate_skill_structure()` - Check skill completeness
- `render_template()` - Template rendering
- `save_with_backup()` - Safe file operations
- `log_skill_usage()` - Analytics tracking

**skill_registry.py** - Discovery system
- `find_by_tag()` - Tag-based search
- `find_by_category()` - Category filtering
- `get_complements()` - Find related skills
- `suggest_workflow()` - Workflow recommendations

**skill_composer.py** - Workflow orchestration
- `compose_workflow()` - Create workflows
- `validate_workflow()` - Check validity
- `execute_workflow()` - Run workflows
- `_resolve_dependencies()` - Order skills

**skill_validator.py** - Quality assurance
- `validate_documentation()` - Check docs
- `validate_scripts()` - Check scripts
- `validate_templates()` - Check templates
- `generate_quality_report()` - Full report

### 3. Individual Skills

Each skill follows a standard structure:

```
skill-name/
├── SKILL.md              # Documentation with frontmatter
├── scripts/              # Executable scripts
│   ├── main.py          # Primary script
│   └── helpers.py       # Helper functions
├── templates/            # Reusable templates
│   └── template.txt     # Template files
└── references/           # Reference materials
    └── examples.md      # Usage examples
```

### 4. Meta-Skills

High-level orchestrators that compose multiple skills.

**Example: full-stack-builder**
- Orchestrates 7-9 skills
- Dynamically adds optional skills
- Resolves dependencies automatically
- Tracks total time saved

---

## Data Flow

### Skill Discovery Flow

```
User Query
    ↓
skill_registry.find_by_tag("database")
    ↓
Load skills.json
    ↓
Filter by tag
    ↓
Return matching skills
```

### Workflow Composition Flow

```
Skill List
    ↓
skill_composer.compose_workflow([...])
    ↓
Load skill metadata from registry
    ↓
Resolve dependencies (topological sort)
    ↓
Validate workflow
    ↓
Return ordered workflow
```

### Workflow Execution Flow

```
Validated Workflow
    ↓
skill_composer.execute_workflow(workflow, context)
    ↓
For each skill in order:
    - Load skill
    - Execute scripts
    - Pass context to next skill
    ↓
Return execution results
```

---

## Skill Structure

### Standard Skill

**Minimum Requirements:**
- `SKILL.md` with frontmatter
- `scripts/` directory with at least one script
- `templates/` directory (can be empty)
- `references/` directory (can be empty)

**Quality Scoring:**
- SKILL.md exists: +2 points
- scripts/ exists: +2 points
- templates/ exists: +1 point
- references/ exists: +1 point
- **Total:** 6 points maximum

**Status Levels:**
- Production: 5-6 points
- Beta: 3-4 points
- Experimental: 0-2 points

### Meta-Skill

**Special Characteristics:**
- Lives in `meta-skills/` directory
- Orchestrates other skills
- Uses skill_registry and skill_composer
- No direct implementation code
- Focuses on workflow composition

---

## Discovery System

### Tag-Based Discovery

Skills are tagged with relevant keywords:

```python
"database-schema-generator": {
    "tags": ["database", "schema", "postgres", "supabase", "sql"]
}
```

**Search:**
```python
registry.find_by_tag("database")
# Returns all skills tagged with "database"
```

### Category-Based Discovery

Skills are organized into 12 categories:

```python
registry.find_by_category("tier1-foundation")
# Returns: [database-schema-generator, api-endpoint-builder, testing-framework]
```

### Complement Discovery

Skills suggest related skills:

```python
registry.get_complements("api-endpoint-builder")
# Returns: [testing-framework, user-authentication-system]
```

### Workflow Suggestions

Registry suggests workflows based on goals:

```python
registry.suggest_workflow("build a SaaS app")
# Returns ordered list of relevant skills
```

---

## Dependency Resolution

### Dependency Types

**Before Dependencies** - Must run before this skill
```json
"api-endpoint-builder": {
    "dependencies": ["database-schema-generator"]
}
```

**After Dependencies** - Should run after this skill
```json
"database-schema-generator": {
    "complements": ["api-endpoint-builder", "testing-framework"]
}
```

### Resolution Algorithm

Simple topological sort:

1. Start with empty ordered list
2. For each skill in workflow:
   - Check if all "before" dependencies are satisfied
   - If yes, add to ordered list
   - If no, wait for dependencies
3. Repeat until all skills ordered
4. Detect circular dependencies

**Example:**
```
Input: [api-endpoint-builder, database-schema-generator, testing-framework]
Dependencies: api-endpoint-builder depends on database-schema-generator
Output: [database-schema-generator, api-endpoint-builder, testing-framework]
```

---

## Meta-Skills

### Purpose

Meta-skills solve the "orchestration problem" - how to combine multiple skills into cohesive workflows.

### Characteristics

1. **No Implementation** - Pure orchestration
2. **Dynamic Composition** - Adapt based on requirements
3. **Dependency Aware** - Respect skill dependencies
4. **Time Tracking** - Aggregate time saved
5. **Error Handling** - Validate before execution

### Example: full-stack-builder

**Base Workflow:**
- brainstorming
- database-schema-generator
- api-endpoint-builder
- user-authentication-system
- testing-framework
- deployment-automation
- error-monitoring-setup

**Optional Skills** (added dynamically):
- payment-integration (if "payments" in features)
- file-upload-system (if "uploads" in features)
- email-system-builder (if "email" in features)

---

## Extension Points

### Adding New Skills

1. Create skill structure using `skill-creator`
2. Implement scripts and templates
3. Write SKILL.md documentation
4. Add to skills.json with metadata
5. Define dependencies and complements
6. Validate with skill_validator

### Adding New Categories

1. Create category directory in `skills/`
2. Update `skill-categories.json`
3. Regenerate `skills.json` manifest
4. Update documentation

### Adding New Meta-Skills

1. Create directory in `meta-skills/`
2. Define workflow composition logic
3. Use skill_registry and skill_composer
4. Add to `skills.json` under `meta_skills`
5. Document workflow and usage

### Extending Shared Utilities

1. Add methods to appropriate utility class
2. Update tests
3. Document new functionality
4. Version bump if breaking changes

---

## Performance Considerations

### Registry Loading

- **Cold Start:** ~50ms to load skills.json
- **Cached:** Instant after first load
- **Optimization:** Keep registry in memory

### Dependency Resolution

- **Complexity:** O(n²) worst case for n skills
- **Typical:** O(n) for well-structured workflows
- **Optimization:** Cache resolved workflows

### Skill Execution

- **Overhead:** Minimal (registry lookup + validation)
- **Bottleneck:** Individual skill execution time
- **Optimization:** Parallel execution where possible

---

## Security Considerations

### Skill Validation

- All skills validated before execution
- Scripts checked for executability
- Templates validated for syntax

### Dependency Safety

- Circular dependencies detected
- Missing skills caught before execution
- Validation prevents invalid workflows

### Isolation

- Skills run in isolated contexts
- No shared state between skills
- Clean context passing

---

## Future Enhancements

### Planned Features

1. **AI-Powered Suggestions** - Use LLM for workflow recommendations
2. **Parallel Execution** - Run independent skills concurrently
3. **Skill Versioning** - Support multiple versions of skills
4. **Remote Skills** - Load skills from external sources
5. **Skill Marketplace** - Share and discover community skills

### Extension Ideas

1. **Visual Workflow Builder** - Drag-and-drop interface
2. **Skill Analytics** - Track usage and performance
3. **Automated Testing** - CI/CD for skill validation
4. **Skill Templates** - Quick-start templates for common patterns
5. **Integration Plugins** - Connect to external tools

---

## Conclusion

The Manus Skills Unified Arsenal provides a **robust, extensible foundation** for AI agent capabilities. The five-layer architecture ensures:

- **Scalability** - Easy to add new skills
- **Maintainability** - Shared utilities prevent duplication
- **Discoverability** - Registry enables intelligent search
- **Composability** - Skills work together seamlessly
- **Quality** - Consistent standards and validation

**The system is production-ready and battle-tested across 55 skills.**
