# PCB review checklists

Use these as decision prompts, not as claims that every item was inspected. Apply only the sections relevant to the user's scope and supplied evidence.

## Schematic and logical review

- Confirm sheet hierarchy, design revision, fitted variant, and named interfaces before tracing connectivity.
- Review power entry, sequencing, enable logic, current/voltage ratings, decoupling intent, grounding, protection, and test access against the stated architecture.
- Review clock, reset, boot/configuration, debug, memory, and high-speed interfaces for polarity, direction, termination, biasing, voltage-domain compatibility, and required no-connect handling.
- Check connector pinout, hot-plug/ESD protection, external signal levels, chassis/shield treatment, and mating-orientation assumptions when evidence exists.
- Flag dangling pins, inconsistent net aliases, ambiguous passive values, missing ratings/tolerances, duplicated reference designators, and undocumented waivers.
- Separate schematic correctness from component availability, layout feasibility, and regulatory compliance.

## BOM and netlist checks

- Match reference designators, quantities, values, footprints, manufacturer part numbers, variants, DNI/DNP state, and alternates across schematic, BOM, and placement/netlist exports.
- Identify duplicate or missing designators, one-to-many value/footprint inconsistencies, unresolved generic parts, lifecycle risk, and substitutions that may change electrical behavior.
- For netlist comparisons, normalize only presentation differences such as ordering; do not normalize renamed nets, changed pin mappings, or revision-specific variant logic without evidence.
- Report whether counts and connectivity were fully compared, sampled, or unavailable.

## PCB physical review

- Establish board outline, stack-up, copper weights, reference planes, impedance targets, via structures, fabrication limits, and constraint classes before evaluating routing.
- Review critical placement for signal path, power-loop area, decoupling proximity, thermal escape, mechanical clearance, connector access, assembly orientation, and rework/test access.
- For high-speed nets, examine topology, layer transitions, return-path continuity, reference changes, breakout geometry, spacing, length/skew rules, stubs, terminations, and coupling risks using declared constraints.
- For power, examine current paths, plane/trace width, neck-downs, via arrays, voltage drop, thermal concentration, return currents, and sense routing. Quantitative conclusions require current, copper, stack-up, and thermal assumptions.
- Review isolation/creepage/clearance only against an identified standard, voltage category, material, environment, and project rule; otherwise state the needed basis.
- Review silkscreen, polarity/pin-1 markings, fiducials, tooling, paste/mask openings, courtyard/keepout conflicts, edge clearances, and panel/assembly constraints when relevant.
- Treat screenshots as localized evidence. State the visible layers, scale, and missing context.

## Release readiness

- Identify exact design revision and verify that schematic, PCB, BOM, constraints, DRC/ERC, drawings, pick-and-place, fabrication outputs, and release notes refer to the same release candidate.
- Review unresolved DRC/ERC items and waivers by rule, object, owner, justification, and expiration or applicability.
- Check fabrication/assembly output completeness and internal consistency, including drill definitions, layer mapping, stack-up notes, controlled impedance, finish, tolerances, assembly variants, centroid/orientation, and special process notes.
- Require a regenerated-output or checksum comparison when stale or mixed-revision exports are suspected.
- State the coverage boundary and residual risks before giving a release-readiness conclusion.
