# Verification report — 2026-09-15

Scope: 86 personal Skill roots and 776 included files. Plugin files and account credentials remain outside the portable backup; 53 plugin-provided Skills are inventoried separately.

## Results

- Source verification against `manifests/personal-skills.json`: **86 passed**.
- Installed Skill health audit: **86/86 discovered**, zero broken local Markdown references and zero missing commands in the repository's known-runtime map.
- Duplicate personal Skill names across `.codex/skills` and `.agents/skills`: **zero**.
- Security scan ran before snapshot export. The scanner was fixed to handle empty text files as empty strings, then the full snapshot was regenerated.

## Engineering runtime checks

| Runtime | Version | Test evidence |
|---|---:|---|
| FreeCAD CLI | 1.1.3 | Created a 10 × 20 × 3 mm solid, exported STEP, imported it again, and recovered one solid with 600 mm³ volume. |
| KiCad CLI | 10.0.6 | Parsed a native `.kicad_pcb` file and generated a DRC report. |
| ngspice | 47 | Solved a 1 kΩ / 1 kΩ DC divider and returned 0.5 V. |
| GNU Octave | unavailable | Both Scoop and winget downloads failed at their upstream mirrors. This does not satisfy MATLAB-specific Skills. |
| MATLAB | unavailable | MATLAB and its licensed toolboxes must be installed separately for the six MathWorks Skills that invoke MATLAB workflows. |

## Reproduce

```powershell
.\scripts\verify.ps1 -AdditionalSkillsRoot "$env:USERPROFILE\.agents\skills"
.\scripts\Test-SkillsHealth.ps1 -SkillRoots "$env:USERPROFILE\.codex\skills","$env:USERPROFILE\.agents\skills" -ExpectedCount 86 -UseKnownRuntimeRequirements
```

The 86/86 result proves local Skill structure, local references and commands covered by the known-runtime map. External accounts, proprietary CAD/EDA licenses, company instruments and cloud API entitlements still require their own authorization.
