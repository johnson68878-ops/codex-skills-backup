# SoC architecture review

Apply only the sections relevant to the requested decision and evidence.

## Requirements and decomposition

- Map product scenarios and workloads to functional blocks, hardware/software partitioning, operating modes, and measurable acceptance criteria.
- Identify cross-cutting services such as clocks, resets, power control, security, debug, telemetry, error management, and test.
- Check that every externally visible requirement has an owning block and verification path; flag duplicate ownership and uncovered behavior.

## Interfaces and integration

- Define initiator/target, protocol and version, data width, frequency, peak and sustainable traffic, ordering, coherency, backpressure, QoS, timeout, error response, clock/reset/power domain, isolation, and observability.
- Check CDC/RDC assumptions, reset sequencing, domain availability, retention, wakeup dependencies, and behavior when either endpoint is unavailable.
- For address space, identify owner, size/alignment, aliasing, privilege/security attributes, cacheability, endianness, discovery, reserved growth, and illegal-access behavior.

## Memory, interconnect, and performance

- Derive traffic from workload events, transaction size, rate, burstiness, read/write mix, concurrency, and protocol overhead.
- Separate theoretical peak, schedulable bandwidth, sustainable bandwidth, and guaranteed service. Include arbitration, contention, refresh, retries, bridges, and clock ratios.
- Track end-to-end latency as a budget across queuing, arbitration, transport, memory/service time, and software-visible deadlines.
- Size buffers from burst and service mismatch assumptions; identify overflow/underflow policy and backpressure propagation.

## Clock, reset, and power

- Identify clock sources, frequencies, ratios, gating, switching, jitter dependencies, and safe-change mechanisms.
- Define reset sources, assertion/deassertion behavior, synchronization, sequence, dependencies, and software-visible state.
- Define power domains, states, retention, isolation, level shifting, sequencing, wakeup sources, state loss, and recovery/error behavior.

## PPA, thermal, and physical feasibility

- State process node/library, voltage/frequency corner, activity/workload, memory/compiler assumptions, package/IO constraints, and maturity of estimates.
- Distinguish pre-RTL estimates, synthesis results, floorplan estimates, and post-route evidence.
- Evaluate area, leakage, dynamic power, peak current, thermal density, congestion, wire delay, macro placement, and package bandwidth as coupled constraints.
- Report sensitivity and uncertainty; avoid false precision.

## Safety, security, reliability, and debug

- Identify assets, trust boundaries, privilege and isolation, secure boot/update, key lifecycle, debug policy, access-control failure behavior, and audit/telemetry needs when in scope.
- Identify fault sources, detection, containment, recovery, diagnostic coverage assumptions, ECC/parity policy, watchdogs, redundancy, and degraded modes when required.
- Ensure observability and controllability are sufficient for bring-up, validation, production test, failure analysis, and field diagnostics without violating security policy.

## Verification and change impact

- Convert architectural contracts into testable properties, scenarios, performance workloads, error injection, coverage goals, and signoff evidence.
- For a proposed change, trace impacts across interfaces, address/register maps, clocks/resets/power, firmware, verification, physical design, safety/security, documentation, and compatibility.

