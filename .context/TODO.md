# Project TODO & Technical Debt

## 1. Immediate Tasks
_Tasks affecting execution reliability, correctness, or security._
- [ ] [`ghcr/delete/action.yaml:27`](file:///Users/i/work/KAnggara/DevOps/ghcr/delete/action.yaml#L27): Update hardcoded branch URL `https://raw.githubusercontent.com/KAnggara/DevOps/refs/heads/feature-dockerbuild/ghcr/func` to dynamic repository reference or relative local execution.
- [ ] [`helmDeploy/action.yaml:18`](file:///Users/i/work/KAnggara/DevOps/helmDeploy/action.yaml#L18): Align GitVersion version between `helmDeploy` (`v4.0.1` / `6.3.x`) and `version` action (`v3.1.1` / `6.0.x`).

## 2. Existing Code Annotations (TODO / FIXME)
_Annotations found directly in source code._
*(No TODO/FIXME annotations found in codebase)*

## 3. Technical Debt & Structural Improvements
_Long-term architectural and refactoring initiatives._
- [ ] **LCOV Action Refactoring**: In [`lcov/action.yaml`](file:///Users/i/work/KAnggara/DevOps/lcov/action.yaml), assess whether compiling TypeScript via Bun in every run is optimal, or if pre-compiling/bundling or pure bash is preferred.
- [ ] **Multi-platform Docker Builds**: Expand [`dockerbuild/build.sh`](file:///Users/i/work/KAnggara/DevOps/dockerbuild/build.sh) to optionally support multi-arch builds (`--platform linux/amd64,linux/arm64`) using `docker buildx`.
- [ ] **Automated Release Tagging**: Implement automated semantic tag releases for the DevOps actions repository itself upon merge to `main`.
