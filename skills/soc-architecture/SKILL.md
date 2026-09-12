---
name: soc-architecture
description: Develop and review system-on-chip architecture artifacts, including requirements, block decomposition, interfaces, address and register maps, clock/reset/power domains, bandwidth and latency budgets, PPA tradeoffs, and verification handoff. Use for architecture exploration, specification reviews, consistency checks, or change-impact analysis; do not claim implementation closure from unverified assumptions or incomplete RTL, workload, process, or physical-design evidence.
---

# SoC Architecture

Produce architecture work that is traceable from system intent to implementation and verification contracts.

## Establish the decision context

Identify the product/use case, workloads, operating points, process and package assumptions, software model, external interfaces, safety/security/reliability goals, schedule stage, and requested artifact. Preserve user-supplied terminology and existing ownership boundaries.

Separate:

- **Requirement:** approved or explicitly supplied behavior or constraint.
- **Assumption:** needed to proceed but not yet confirmed.
- **Derived estimate:** calculated from stated inputs and method.
- **Proposal:** an architectural choice awaiting decision.
- **Open issue:** missing or conflicting information that affects closure.

Never silently convert an assumption or estimate into a requirement.

## Select the work mode

- For decomposition, interfaces, data/control flow, interconnect, memory hierarchy, clock/reset/power domains, boot/debug, coherency, isolation, or integration review, read [references/architecture-review.md](references/architecture-review.md).
- For bandwidth, latency, buffering, utilization, PPA, thermal, reliability, safety, security, or workload tradeoffs, read the relevant sections of [references/architecture-review.md](references/architecture-review.md).
- For specifications, interface matrices, address maps, register plans, decision records, risk registers, or verification handoff, read [references/artifact-contracts.md](references/artifact-contracts.md).

Use only the sections relevant to the requested decision. Avoid producing a full architecture package for a narrow question.

## Preserve traceability and consistency

Link major architectural choices to requirements, assumptions, workloads, and measurable acceptance criteria. Cross-check block diagrams, interface tables, address maps, register descriptions, clock/reset/power intent, performance budgets, security boundaries, and verification plans for contradictions.

Quantitative estimates must show units, operating point, traffic/workload model, efficiency or contention assumptions, formula or method, and sensitivity to uncertain inputs. Do not treat peak bandwidth as sustainable throughput, logical gate count as routed area, or nominal power as worst-case thermal demand.

When alternatives exist, compare them against the user's decision criteria and identify irreversible commitments, integration cost, verification burden, software impact, and residual risk. Recommend one only when the evidence and priorities support it.

## Deliver implementable contracts

State ownership and behavior at each boundary: producer/consumer, protocol, clock/reset/power domain, ordering/coherency, backpressure, error response, initialization, observability, and verification method. Highlight release-blocking inconsistencies first.

Do not modify RTL, firmware, register databases, implementation constraints, or approved specifications unless explicitly requested. Keep proposed changes separate from accepted architecture decisions.
