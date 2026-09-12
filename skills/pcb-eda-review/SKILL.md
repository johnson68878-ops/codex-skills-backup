---
name: pcb-eda-review
description: Review PCB design evidence from OrCAD, Allegro, or PADS, including schematics, netlists, BOMs, constraints, DRC reports, fabrication outputs, and annotated screenshots. Use for design reviews, issue triage, release-readiness checks, or comparison of PCB revisions; do not claim signoff from incomplete evidence or treat proprietary binary files as fully parsed when only exports are available.
---

# PCB EDA Review

Perform an evidence-backed electrical and physical design review while preserving the engineer's chosen EDA tool and project conventions.

## Establish the review basis

Identify the requested scope, board/revision, intended deliverable, and supplied artifacts. Prefer read-only exports such as searchable schematic PDFs, BOM/netlist/constraint CSVs, DRC reports, stack-up and impedance tables, fabrication notes, IPC-2581/ODB++ summaries, and annotated screenshots.

Native OrCAD/Allegro/PADS files may be proprietary or version-dependent. State what was actually inspected. If a native file cannot be parsed reliably, request or recommend the smallest export that answers the review question; do not imply full database coverage.

Record missing evidence that limits conclusions, especially power-tree data, signal classes, stack-up, impedance rules, component models, placement context, return paths, fabrication capabilities, or approved waivers. Continue with useful partial analysis when possible.

## Select the review mode

- For schematic connectivity, component usage, BOM/netlist consistency, power/reset/clock interfaces, or ERC findings, read [references/review-checklists.md](references/review-checklists.md), sections **Schematic and logical review** and **BOM and netlist checks**.
- For placement, routing, constraints, DRC, SI/PI indicators, EMC, thermal, DFM, or release outputs, read [references/review-checklists.md](references/review-checklists.md), sections **PCB physical review** and **Release readiness**.
- For a formal review report, issue table, redline list, or revision comparison, also read [references/reporting.md](references/reporting.md).

Use only the relevant sections; do not turn every review into an exhaustive signoff checklist.

## Analyze and cross-check

Trace important findings across independent evidence when available: schematic to netlist, BOM to fitted variants, constraint definition to DRC result, layout observation to stack-up/return path, and release note to generated fabrication files.

Distinguish:

- **Observed:** directly supported by a file, report, screenshot, or measured value.
- **Inferred risk:** technically plausible but dependent on missing context.
- **Unverified:** cannot be concluded from supplied evidence.

Never present visual inspection alone as SI, PI, EMC, thermal, safety, or manufacturability signoff. Treat tool-clean ERC/DRC as necessary evidence, not proof that system intent is correct.

For conflicting artifacts, report the conflict and identify the authoritative source only if the user or project documentation establishes one. Do not silently reconcile design revisions.

## Deliver actionable results

Lead with release-blocking or high-risk issues. For every finding, include evidence location, affected object or net/component, technical consequence, recommended disposition, and verification method. Keep suggested edits separate from confirmed design changes.

Do not modify source designs, approve waivers, alter constraints, regenerate manufacturing outputs, or mark a design released unless the user explicitly requests that action and the environment supports it. Preserve original artifacts and revision identity.
