# SoC architecture artifact contracts

Use these fields when the user requests a formal artifact. Adapt rather than emitting empty boilerplate.

## Architecture decision record

Capture decision, status, context, requirements, assumptions, alternatives, evaluation criteria, evidence, selected option, consequences, risks, owner, and validation plan.

## Interface matrix

Capture endpoints and owners; protocol/version; direction; data/address width; clock/reset/power domain; frequency; peak/sustainable traffic; latency/QoS; ordering/coherency; backpressure; error/timeout; security attributes; initialization; observability; and verification owner.

## Address and register planning

For address regions, capture base, size, alignment, owner, access path, privilege/security, cacheability, endianness, aliasing, reserved growth, and illegal-access behavior.

For register plans, capture purpose, offset/width, reset value and reset domain, access semantics, field ownership, side effects, atomicity, synchronization, privilege/security, error behavior, and hardware/software verification. Do not invent bit assignments when only behavior is defined.

## Performance budget

Capture scenario/workload, metric and target, path, contributors, operating point, calculation/model, efficiency/contention assumptions, margin, evidence maturity, sensitivity, and validation method.

## Review output

Lead with decision blockers and contradictions. For each issue provide severity, source location, affected contract, technical consequence, proposed disposition, owner if supplied, and closure evidence. Summarize unresolved assumptions and residual risk separately from confirmed defects.

