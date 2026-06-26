# Security Policy

## Supported Versions

The supported security scope for `arkit-lacroix` is the current default branch, `master`. Older commits, tags, branches, forks, demos, and generated artifacts are not actively supported unless the repository explicitly marks them as maintained.

Project summary: A raining lacroix app built using Unity and ARKit

## Reporting a Vulnerability

Please report suspected vulnerabilities through GitHub's private vulnerability reporting or by opening a draft GitHub Security Advisory for `garethpaul/arkit-lacroix` when that option is available. If GitHub does not show a private reporting option for this repository, contact the repository owner through GitHub and avoid posting exploit details publicly until the issue can be assessed.

Do not open a public issue that includes exploit code, secrets, personal data, or detailed reproduction steps for an unpatched vulnerability.

## What to Include

Helpful reports include:

- the affected file, endpoint, permission, dependency, or workflow
- a concise impact statement explaining what an attacker could do
- reproduction steps using test data and accounts you control
- the branch, commit SHA, platform version, device, runtime, or dependency versions used
- logs, screenshots, or proof-of-concept snippets that demonstrate impact without exposing private data

## Project Security Posture

- This repository appears to be a public sample, documentation, or utility project. The active security scope is the code and documentation on the default branch.
- Review found authentication, token, or session-related code paths; changes in those areas should receive security-focused review before merge.
- Review found external API integrations or credential-adjacent configuration; changes in those areas should receive security-focused review before merge.
- Unity project settings keep the unused PSP2 package-password field blank; `make check` rejects tracked password material in that field.
- Review found network clients, sockets, web APIs, or service endpoints; changes in those areas should receive security-focused review before merge.
- Review found mobile permission or privacy-sensitive data handling; changes in those areas should receive security-focused review before merge.
- Review found file, document, data, or media parsing flows; changes in those areas should receive security-focused review before merge.
- No primary dependency manifest was detected in the repository root. If dependencies are added later, include a manifest and prefer reproducible installation instructions.
- GitHub Actions runs the SDK-free `make check` baseline with a commit-pinned checkout action, read-only repository access, and a bounded runtime; review workflow, checker, and generated Unity metadata changes as part of the supply-chain surface.
- Hosted `make check` installs pinned .NET tooling and compiles eleven production
  ARKit native-interface sources, then executes ABI layout and enum-value
  contracts. This evidence does not cover Unity-dependent scripts or native iOS
  bridge compilation.
- `ParticlePainter` bounds accepted AR movement between repaired minimum and
  maximum thresholds so relocalization jumps do not create unintended paint
  geometry or unbounded spatial samples.
- ParticlePainter caps active and completed paint systems and releases owned systems on destruction.
- Point-cloud examples release AR frame listeners and owned scene objects during lifecycle teardown.
- ColorPresets removes its runtime color listener during teardown so the picker
  cannot retain a callback targeting a destroyed component.
- ColorPickerTester removes its runtime color listener during teardown so the
  test picker cannot retain a callback targeting a destroyed renderer owner.
- Point-cloud examples clear pending AR frame data when disabled before accepting a new enabled-lifetime frame.
- Point-cloud markers hide when they are not represented by the current AR frame.
- Point-cloud renderers omit non-finite AR coordinates before writing Unity positions.
- UnityPointCloudExample repairs invalid marker counts before allocation so malformed serialization cannot create more than 1,000 owned markers.
- AR hit-test interactions reject non-finite spawn and movement coordinates before writing Unity transforms.
- The UnityARBallz BallMaker caps retained balls, prunes missing objects, evicts
  oldest ownership first, and releases retained balls when disabled.
- UnityARBallz BallMover releases its tracked object before replacement and when disabled.
- UnityARVideo reuses its external texture pair and releases it on teardown.
- UnityARVideo detaches and releases its command buffer on disable and destroy
  so inactive camera components do not retain native rendering resources.

## Service and API Notes

For web services, APIs, sockets, or scraping workflows, prioritize reports involving authentication bypass, authorization errors, injection, server-side request forgery, unsafe deserialization, credential leakage, data exposure, or denial-of-service conditions. Use test accounts and minimal proof-of-concept traffic only.

## Dependency and Supply Chain Security

Dependency updates should come from trusted package managers and should keep lockfiles in sync when lockfiles exist. Do not commit credentials, private keys, tokens, generated secrets, or machine-local configuration. If a vulnerability depends on a compromised package, typosquatting risk, insecure transitive dependency, or unsafe build step, include the package name, affected version, and the path through which it is used.

CodeQL default-setup results cover GitHub Actions and Unity C#. The
Objective-C++ bridge is not covered by the successful default-setup jobs;
triage findings and that native gap without weakening scene/source contracts
or treating static analysis as a substitute for Unity 5.6.1p1 verification.

## Safe Research Guidelines

Good-faith research is welcome when it stays within these boundaries:

- use only accounts, devices, data, and infrastructure that you own or have explicit permission to test
- avoid destructive actions, persistence, spam, phishing, social engineering, or denial-of-service testing
- minimize access to personal data and stop testing immediately if private data is exposed
- do not exfiltrate secrets or third-party data; report the minimum evidence needed to verify impact
- keep vulnerability details confidential until the maintainer has assessed the report

## Maintainer Response

The maintainer will review complete reports as availability allows, prioritize issues by exploitability and impact, and coordinate a fix or mitigation when the affected code is still maintained. For sample, archived, or educational repositories, the likely remediation may be documentation, dependency updates, or clearly marking unsupported code rather than a production-style patch release.
