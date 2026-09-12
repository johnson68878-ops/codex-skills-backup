# Evidence-backed PCB review reporting

Use this format when the user requests a formal report, issue register, design-review minutes, or revision comparison.

## Review header

Capture board/project, revision, EDA tool/version when known, review objective, artifacts inspected, exclusions, and date. Identify whether the review is full, scoped, or sampled.

## Finding fields

For each finding, provide:

- ID and concise title
- Severity: Blocker, High, Medium, Low, or Informational
- Status: Observed, Inferred risk, or Unverified
- Evidence: file/report/sheet/page/coordinate/layer/rule, plus affected net, component, pin, or region
- Technical consequence
- Recommended disposition
- Verification or closure evidence
- Owner or waiver reference only when supplied

Use **Blocker** for evidence of a condition that prevents the stated release objective or creates an unacceptable safety/destructive risk. Use **High** for likely functional, reliability, compliance, or manufacturing failure. Use **Medium** for material risk with workaround or uncertain occurrence. Use **Low** for limited-impact quality/maintainability issues. Use **Informational** for observations without a requested corrective action.

## Summary and closure

Summarize counts by severity, release-impacting items, key evidence gaps, and residual risks. A finding is closed only when the stated verification evidence is available; a proposed edit or verbal agreement is not closure.

For revision comparisons, list added, removed, and changed evidence separately, and distinguish intentional change from unexplained drift. Do not infer intent solely from file differences.
