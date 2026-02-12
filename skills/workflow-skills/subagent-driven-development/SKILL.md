---
name: subagent-driven-development
description: A systematic, phase-based approach for complex software development tasks. Use when building multi-component applications, implementing features with many moving parts, or when the user requests a highly organized and methodical development process. This skill is ideal for projects requiring detailed planning, execution tracking, and comprehensive documentation.
---

# Subagent-Driven Development

This skill provides a structured, phase-based methodology for complex software development projects. It ensures a high degree of organization, clear communication, and robust documentation throughout the development lifecycle. It is particularly effective for building multi-component applications where a systematic approach is critical for success.

## Core Principles

*   **Plan, then Execute:** Always create a detailed implementation plan before writing any code.
*   **Phase-Based Progression:** Break down the project into logical phases and complete them sequentially.
*   **Task-Oriented Execution:** Within each phase, execute small, well-defined tasks.
*   **Continuous Feedback:** Provide regular updates to the user after each task or phase.
*   **Comprehensive Documentation:** Maintain a detailed execution log to track progress, decisions, and outcomes.

## The Subagent-Driven Development Workflow

This workflow consists of two main loops: the **Outer Loop** (planning and overall project management) and the **Inner Loop** (task execution).

### Outer Loop: Project Setup and Planning

1.  **Understand the Goal:** Work with the user to define the high-level objectives of the project.
2.  **Create the Main Plan:** Use the `plan` tool to create a high-level, multi-phase plan for the entire project. This plan should cover all major stages, from setup to delivery.
3.  **Execute the Main Plan:** Begin executing the main plan, advancing through the phases as they are completed.

### Inner Loop: Per-Phase Implementation

For each development-heavy phase in the main plan (e.g., "Build Game UI"), follow this inner loop:

**1. Create an Implementation Plan:**

*   Before writing any code for the phase, create a detailed implementation plan.
*   Use the template provided in `/home/ubuntu/skills/subagent-driven-development/references/implementation_plan_template.md`.
*   This plan should break down the phase into smaller, manageable tasks.
*   Review the plan with the user to ensure alignment.

**2. Create an Execution Plan:**

*   Create a new, temporary plan using the `plan` tool that reflects the tasks outlined in the implementation plan.
*   This plan is for tracking the execution of the current phase only.

**3. Execute Tasks Systematically:**

*   Work through each task in the execution plan one by one.
*   For each task:
    *   Write the necessary code.
    *   Commit the changes with a clear and descriptive message.
    *   Provide a brief update to the user.

**4. Document Everything in an Execution Log:**

*   As you complete tasks, document the process in an execution log.
*   Use the template provided in `/home/ubuntu/skills/subagent-driven-development/references/execution_log_template.md`.
*   This log should include:
    *   A summary of the work completed.
    *   Key architectural decisions.
    *   Code snippets for critical components.
    *   Any lessons learned.

**5. Complete the Phase:**

*   Once all tasks in the execution plan are complete, run any necessary checks (e.g., TypeScript compilation, linting).
*   Commit the final execution log.
*   Revert to the main project plan and advance to the next phase.

## When to Use This Skill

This skill is most effective for:

*   **Complex Applications:** Projects with multiple components, such as a frontend, backend, and database.
*   **Multi-Step Features:** Implementing new features that require changes across different parts of the codebase.
*   **Methodical Users:** When the user explicitly requests a highly organized, step-by-step development process.
*   **Long-Term Projects:** When detailed documentation and clear tracking are essential for maintainability.

By following this structured approach, you can ensure that complex development projects are completed efficiently, with high quality, and in a way that is transparent and easy for the user to follow.
