# Mechanical design review

Apply only the sections relevant to the requested scope and supplied evidence.

## Part and feature design

- Confirm intended function, interfaces, units, material, process, finish, critical characteristics, and load/environment assumptions.
- Review minimum walls, ribs/bosses, fillets, draft, undercuts, tool access, bend/radius rules, machining reach, additive constraints, stress concentrations, sharp edges, and inspection access as applicable to the chosen process.
- Flag fragile references, unnecessary complexity, zero-thickness/self-intersection risks, imported-geometry uncertainty, and features that obscure design intent when supported by evidence.

## Assembly and interfaces

- Confirm configuration/simplified representation, component state, external references, coordinate systems, and mating/interface ownership.
- Review interference and minimum clearance across full motion, tolerance, thermal expansion, deformation, cable/hose routing, service access, tooling, and assembly sequence.
- Review fastener type/grade/length, engagement, edge distance, preload/locking assumptions, tool clearance, captive hardware, and mixed-material or galvanic concerns when relevant.
- Review connector access, datum transfer, alignment, locating strategy, overconstraint, stack direction, replaceability, and poka-yoke features.
- Treat CAD interference results as configuration- and position-specific; state whether envelopes, flexible parts, and all mechanism states were included.

## Loads, thermal, and mass properties

- Identify load cases, constraints, contact, material allowables, duty cycle, temperature, shock/vibration, fatigue, and required safety/reliability factors before quantitative conclusions.
- Distinguish hand calculations, CAD mass properties, FEA results, test data, and engineering estimates.
- Review center of mass, inertia, mounting reactions, thermal interfaces, expansion mismatch, ventilation/contact assumptions, and tolerance effects where in scope.
- Never infer structural or thermal signoff from geometry alone.

## DFM and DFA

- Evaluate geometry against the named manufacturing and assembly process, supplier capability, material, production volume, inspection plan, and cost/quality priorities.
- Identify special tooling, secondary operations, inaccessible inspection features, datum/process mismatch, difficult fixturing, tolerance-cost drivers, orientation/handling risks, and ambiguous assembly order.
- Separate general manufacturability risk from supplier-approved capability.

