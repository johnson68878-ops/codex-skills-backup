---
name: mechanical-cad-review
description: Review mechanical CAD evidence from Creo or SOLIDWORKS, including parts, assemblies, drawings, BOMs, interference and mass-property reports, neutral exports, and annotated screenshots. Use for design reviews, tolerance/GD&T checks, DFM/DFA assessment, revision comparison, or release readiness; do not claim solved geometry, fit, strength, or manufacturability from incomplete or view-only evidence.
---

# Mechanical CAD Review

Perform an evidence-backed mechanical design review while preserving the engineer's CAD system, configuration, units, and revision structure.

## Establish the review basis

Identify product/assembly, revision and configuration, Creo or SOLIDWORKS version when known, units, material/process, operating environment, interfaces, applicable standards, and requested deliverable. Record whether evidence is native, neutral geometry, drawing, report, or screenshot.

Native CAD files may be version-dependent and may rely on external references, family tables, configurations, simplified representations, or suppressed features. State what was actually inspected. Prefer the smallest additional export that resolves uncertainty, such as STEP/Parasolid/JT, searchable drawing PDF, DXF, BOM CSV, interference/clearance report, mass properties, tolerance study, or sectioned screenshot.

## Select the review mode

- For part geometry, assemblies, interfaces, clearances, mechanisms, fasteners, materials, mass properties, thermal paths, or manufacturability, read [references/mechanical-review.md](references/mechanical-review.md).
- For drawings, dimensions, datums, GD&T, tolerance stacks, surface finish, notes, BOMs, configurations, revisions, or release packages, read [references/drawing-release-review.md](references/drawing-release-review.md).

Use only the relevant sections. Do not imply that hidden features, suppressed components, or unprovided configurations were reviewed.

## Evaluate evidence and risk

Distinguish direct observation, calculated result, inferred risk, and unverified condition. For calculations, state units, load cases, boundary conditions, material data, tolerance model, safety factor, and source of inputs.

Do not treat visual clearance as an interference solution, nominal dimensions as tolerance closure, a clean CAD rebuild as functional validation, or a drawing review as FEA/thermal/kinematic/manufacturing signoff. Identify when tool-native regeneration, simulation, measurement, supplier capability, or prototype testing is required.

Cross-check model, drawing, BOM, configuration, material, finish, mass properties, manufacturing notes, and released neutral outputs for revision consistency. Report conflicts without silently choosing an authoritative artifact unless the user or release process defines it.

## Deliver actionable findings

Lead with safety, fit/function, and release-blocking issues. Each finding should identify evidence location, affected feature/component/interface, technical consequence, recommended disposition, and closure evidence. Separate proposed changes from confirmed model edits.

Do not modify CAD models, suppress features, change dimensions/tolerances/materials, update BOMs, or release files unless explicitly requested and supported by the environment. Preserve original files, configurations, external references, and revision identity.
