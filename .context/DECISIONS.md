# Architecture Decision Records (ADRs)

## ADR-001: Composite GitHub Actions Architecture
- **Status**: Accepted
- **Date**: 2026-10-05
- **Source**: Codebase evidence (`*/action.yaml`)
- **Context**: Centralizing and standardizing build, test, and release mechanisms across multiple repositories without requiring heavy third-party marketplace dependencies or fragmented script copies.
- **Decision**: Encapsulate CI/CD logic into reusable Composite Actions with standalone shell scripts (`action.yaml` calling shell entry points).
- **Consequences**:
  - High reusability and centralized maintenance.
  - Testable locally with minimal runtime prerequisites beyond Docker, bash, and standard CLI tools.
  - Requires consumer repositories to check out or reference `KAnggara/DevOps/<action>@<ref>`.

---

## ADR-002: Docker BuildKit Caching and Dynamic Branch Tagging
- **Status**: Accepted
- **Date**: 2026-10-05
- **Source**: Commit history (`a06db71`, `1d71b94`) and [`dockerbuild/build.sh`](file:///Users/i/work/KAnggara/DevOps/dockerbuild/build.sh)
- **Context**: Image building was repeatedly rebuilding identical layers on CI runners, slowing pipeline throughput, and tag naming lacked branch environment separation.
- **Decision**:
  - Enable `DOCKER_BUILDKIT=1`.
  - Use `--cache-from ${REGISTRY}/${IMAGE_NAME}:latest` and `--build-arg BUILDKIT_INLINE_CACHE=1`.
  - Dynamically assign tag prefixes: `release-*` for `main`/`master`, `sit-*` for `feature-*`, and `dev-*` for other branches.
- **Consequences**:
  - Noticeable decrease in build duration on recurring workflows.
  - Automatic differentiation of container artifacts across SIT, Dev, and Production environments.

---

## ADR-003: Helm Deployments Driven by Git Diff Detection
- **Status**: Accepted
- **Date**: 2026-10-05
- **Source**: Codebase evidence in [`helmDeploy/deploy.sh`](file:///Users/i/work/KAnggara/DevOps/helmDeploy/deploy.sh)
- **Context**: In multi-service repositories, running redeployments for unmodified applications creates unnecessary Kubernetes churn and pipeline latency.
- **Decision**: Detect modified services by running `git diff --name-only "$REF_BASE" "$REF_HEAD"` targeting `apps/*.yaml`, deploying only services with explicit changes using `helm upgrade --install --atomic`.
- **Consequences**:
- Selective deployments prevent unnecessary rollouts.
- Requires consumer repositories to follow the convention of maintaining values files under `apps/<app-name>.yaml`.

---

## ADR-004: Root Action Metadata for GitHub Actions Marketplace
- **Status**: Accepted
- **Date**: 2026-10-05
- **Source**: Codebase evidence ([`action.yml`](file:///Users/i/work/KAnggara/DevOps/action.yml)) & Developer request
- **Context**: GitHub Actions Marketplace mandates an `action.yml` file located directly at the repository root with mandatory metadata (`name`, `author`, `branding`) to enable publishing.
- **Decision**: Place an umbrella/meta `action.yml` composite action at the root with official branding metadata, while preserving modular sub-actions in their respective directories (`test/`, `dockerbuild/`, `mavenbuild/`, etc.).
- **Consequences**:
- Enables listing on GitHub Actions Marketplace.
- Downstream users can consume individual sub-actions (`KAnggara/DevOps/<sub-action>@<version>`) or the root action.

---

## ADR-005: Unified Multi-Action Integration Testing Suite with @latest
- **Status**: Accepted
- **Date**: 2026-10-05
- **Source**: Codebase evidence ([`.github/workflows/testAll.yaml`](file:///Users/i/work/KAnggara/DevOps/.github/workflows/testAll.yaml))
- **Context**: Testing individual actions in isolated workflows left potential regressions between shared runner environments and the rolling `latest` release tag undetected.
- **Decision**: Create a comprehensive integration workflow (`testAll.yaml`) running parallel jobs for all actions utilizing the `@latest` release tag.
- **Consequences**:
- Immediate automated verification of all actions before and after new releases.
- Ensures the `latest` pointer functions correctly across diverse runtimes (Go, Node, Java, Bun).
