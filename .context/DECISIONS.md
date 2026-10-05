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
