---
name: to-issues
description: Break a plan, spec, or PRD into independently-grabbable issue markdown files using tracer-bullet vertical slices. Use when user wants to convert a plan into implementation tickets or break down work into issues.
---

# To Issues

Break a plan into independently-grabbable issue files using vertical slices (tracer bullets).

## Process

### 1. Gather context

Work from whatever is already in the conversation context.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code.

### 3. Draft vertical slices

Break the plan into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be "HITL" or "AFK". HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Create markdown issue files

For each approved slice, create a markdown file in:

`.plans/{title-from-prd}/`

Where `{title-from-prd}` is a filesystem-safe slug derived from the PRD title (lowercase, spaces/special chars converted to `-`).

Create files in dependency order (blockers first), using numbered filenames so order is clear:

- `001-{slice-title-slug}.md`
- `002-{slice-title-slug}.md`
- etc.

Use the issue body template below in each file.

<issue-template>
# {Slice title}

## ID

SLICE-001 (increment per file)

## Type

AFK or HITL

## Parent

PRD: {prd-title}

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- SLICE-00X (`{filename}.md`) (if any)

Or "None - can start immediately" if no blockers.

## User stories covered

- Story X
- Story Y
</issue-template>
