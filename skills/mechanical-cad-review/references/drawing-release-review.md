# Mechanical drawing and release review

## Drawing and GD&T

- Confirm drawing/model revision, configuration, units, projection, scale, sheet coverage, title-block data, material, finish, process, and referenced standards.
- Check that functional requirements are defined without redundant or contradictory dimensions; identify missing dimensions, ambiguous origins, duplicate callouts, and model/drawing conflicts.
- Review datum reference frames, feature-control frames, basic dimensions, modifiers, pattern controls, profile boundaries, projected zones, and inspection feasibility against functional intent.
- Do not declare GD&T correct without understanding assembly function, datum establishment, and inspection method.

## Tolerance stacks

- Define the functional requirement, stack path, sign convention, contributors, distribution/limit model, correlation assumptions, thermal and process effects, and acceptance margin.
- Separate worst-case, RSS/statistical, Monte Carlo, measured capability, and nominal analysis. Report sensitivity and dominant contributors.
- Do not combine unilateral, geometric, and assembly-shift effects without an explicit model.

## BOM, configurations, and change control

- Cross-check item numbers, part numbers, descriptions, quantities, materials/finishes, make/buy state, alternates, hardware, configuration applicability, and drawing/model revisions.
- Identify suppressed/excluded components, family-table or configuration drift, unresolved references, and released outputs that do not match the target assembly state.
- For revision comparisons, distinguish intentional change, propagated dependency change, and unexplained drift. Include affected interfaces, tooling, inspection, inventory, documentation, and qualification.

## Release readiness

- Confirm the same release candidate across models, drawings, BOM, neutral exports, manufacturing data, analysis reports, and release notes.
- Identify unresolved rebuild errors, interference items, tolerance gaps, missing material/finish/process definitions, unapproved deviations, and stale exports.
- State review coverage, exclusions, residual risk, and required closure evidence. A proposed edit or clean visual review is not closure.

## Finding format

For each issue provide severity, status (observed/inferred/unverified), file/configuration/sheet/view/feature or component location, technical consequence, recommended disposition, and verification evidence. Reserve Blocker for conditions that prevent the stated release objective or create unacceptable safety/destructive risk.
