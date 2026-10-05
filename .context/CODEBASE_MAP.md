# Codebase Navigation Map

## Overview
Repository `KAnggara/DevOps` contains reusable GitHub Composite Actions and shell orchestration scripts supporting multi-runtime CI/CD workflows (Java/Maven, TypeScript/Bun, Go, Node.js, Docker/Podman, GHCR management, and Helm/Kubernetes deployments).

---

## 0. Root Action (`action.yml`)
- **Responsibility**: Marketplace entrypoint and meta action descriptor for GitHub Actions Marketplace compatibility.
- **Entry / Key Files**:
  - [`action.yml`](file:///Users/i/work/KAnggara/DevOps/action.yml) — Defines GitHub Marketplace branding metadata (`icon: play-circle`, `color: blue`), author, and action description.
- **Consumers**: GitHub Marketplace directory.

---

## 1. `dockerbuild/`
- **Responsibility**: Container image building and pushing to container registries (GHCR / Docker registries) with BuildKit cache optimization and dynamic tagging strategies.
- **Entry / Key Files**:
  - [`dockerbuild/action.yaml`](file:///Users/i/work/KAnggara/DevOps/dockerbuild/action.yaml) — Composite action definition exposing inputs (`path`, `dockerfile_path`, `username`, `password`, `registry`, `image_name`, `tag_strategy`).
  - [`dockerbuild/build.sh`](file:///Users/i/work/KAnggara/DevOps/dockerbuild/build.sh) — Docker login, BuildKit activation (`DOCKER_BUILDKIT=1`), cache inline tagging, dynamic environment tag formatting (`main`/`master` -> `release-*`, `feature-*` -> `sit-*`, default -> `dev-*`), and push execution.
  - [`dockerbuild/post.sh`](file:///Users/i/work/KAnggara/DevOps/dockerbuild/post.sh) — Cleanup step removing Docker credentials (`docker logout`).
- **Dependencies**: Docker CLI / BuildKit, bash.
- **Consumers**: Upstream CI/CD caller workflows (`.github/workflows/dockerbuild.yaml`).
- **Key Notes**: [CONFIRMED] Utilizes `--cache-from ${REGISTRY}/${IMAGE_NAME}:latest` and `--build-arg BUILDKIT_INLINE_CACHE=1` for layer re-use.

---

## 2. `ghcr/`
- **Responsibility**: GitHub Container Registry (GHCR) utilities, specifically package version pruning and image retention cleanup.
- **Entry / Key Files**:
  - [`ghcr/delete/action.yaml`](file:///Users/i/work/KAnggara/DevOps/ghcr/delete/action.yaml) — Composite action managing image deletion with inputs `github_token`, `keep_release`, and `keep_non_release`.
  - [`ghcr/delete/delete.sh`](file:///Users/i/work/KAnggara/DevOps/ghcr/delete/delete.sh) — Remote/local function coordinator invoking cleanup logic.
  - [`ghcr/delete/post.sh`](file:///Users/i/work/KAnggara/DevOps/ghcr/delete/post.sh) — Post-action registry logout.
  - [`ghcr/func/delete_image.sh`](file:///Users/i/work/KAnggara/DevOps/ghcr/func/delete_image.sh) — Pruning algorithm filtering release tags vs non-release tags via GitHub REST API.
  - [`ghcr/func/get_version.sh`](file:///Users/i/work/KAnggara/DevOps/ghcr/func/get_version.sh) — Version lookup helper via GitHub API.
  - [`ghcr/func/gh_login.sh`](file:///Users/i/work/KAnggara/DevOps/ghcr/func/gh_login.sh) — GitHub Container Registry authentication helper.
- **Dependencies**: GitHub REST API (`ghcr.io`), curl, jq, bash.
- **Consumers**: Caller workflows requiring scheduled or post-build GHCR hygiene (`.github/workflows/ghcr_delete.yaml`).
- **Key Notes**: [CONFIRMED] Defaults retention to 5 release images and 2 non-release images.

---

## 3. `helmDeploy/`
- **Responsibility**: Automated Helm-based deployment to Kubernetes clusters driven by Git diff detection.
- **Entry / Key Files**:
  - [`helmDeploy/action.yaml`](file:///Users/i/work/KAnggara/DevOps/helmDeploy/action.yaml) — Installs GitVersion (`6.3.x`) and Helm (`Azure/setup-helm@v4.3.0`), decoding base64 kubeconfig.
  - [`helmDeploy/deploy.sh`](file:///Users/i/work/KAnggara/DevOps/helmDeploy/deploy.sh) — Analyzes diff in `apps/*.yaml` between `REF_BASE` and `REF_HEAD`, injects SemVer into `chart/Chart.yaml`, and invokes `helm upgrade --install` atomically.
- **Dependencies**: `Azure/setup-helm`, `gittools/actions/gitversion`, kubectl, bash.
- **Consumers**: Continuous deployment pipelines (`git diff` driven).
- **Key Notes**: [CONFIRMED] Requires `KUBECONFIG_DATA` base64 secret; runs Helm with `--atomic --timeout 5m` into namespace `default`.

---

## 4. `lcov/`
- **Responsibility**: Code coverage processing and HTML reporting generation via LCOV and Bun.
- **Entry / Key Files**:
  - [`lcov/action.yaml`](file:///Users/i/work/KAnggara/DevOps/lcov/action.yaml) — Setup composite action invoking LCOV installation, HTML report compilation, and Bun runtime execution.
  - [`lcov/setup.sh`](file:///Users/i/work/KAnggara/DevOps/lcov/setup.sh) — Installs `lcov` via system package manager (apt/brew).
  - [`lcov/execute.sh`](file:///Users/i/work/KAnggara/DevOps/lcov/execute.sh) — Generates HTML reports with `genhtml` from input coverage file.
  - [`lcov/src/main.ts`](file:///Users/i/work/KAnggara/DevOps/lcov/src/main.ts) — TypeScript utility compiled via `bun build --compile`.
- **Dependencies**: LCOV, Bun (`oven-sh/setup-bun@v2`).
- **Consumers**: Test workflows tracking code coverage (`.github/workflows/lcov.yaml`).

---

## 5. `mavenbuild/`
- **Responsibility**: Java Maven project build packaging with application configuration injection and GitHub artifact publishing.
- **Entry / Key Files**:
  - [`mavenbuild/action.yaml`](file:///Users/i/work/KAnggara/DevOps/mavenbuild/action.yaml) — Prepares Eclipse Temurin Java (default JDK 21), runs build script, and archives jar output to GitHub artifacts.
  - [`mavenbuild/mavenbuild.sh`](file:///Users/i/work/KAnggara/DevOps/mavenbuild/mavenbuild.sh) — Writes secret properties to `application.properties`, selects `./mvnw` or `mvn clean package`, and isolates jar files to `mavenbuild/` output directory.
- **Dependencies**: Java (Temurin 21 default), Maven / Maven Wrapper (`mvnw`), `actions/upload-artifact@v4`.
- **Consumers**: Backend CI build pipelines (`.github/workflows/mavenbuild.yaml`).

---

## 6. `test/` (Testing Suite Actions)
- **Responsibility**: Modular automated testing execution across Bun (TypeScript/JavaScript), Go (Golang), Java (Maven), and Node.js.
- **Sub-actions**:
  - **`test/bun/`**:
    - [`test/bun/action.yaml`](file:///Users/i/work/KAnggara/DevOps/test/bun/action.yaml) — Sets up Bun runtime (`oven-sh/setup-bun@v2`).
    - [`test/bun/buntest.sh`](file:///Users/i/work/KAnggara/DevOps/test/bun/buntest.sh) — Generates `.env` from secret inputs, executes `bun test --coverage`.
  - **`test/go/`**:
    - [`test/go/action.yaml`](file:///Users/i/work/KAnggara/DevOps/test/go/action.yaml) — Sets up Go runtime (`actions/setup-go@v5`), supports `.env` configuration, and optional coverage output.
    - [`test/go/gotest.sh`](file:///Users/i/work/KAnggara/DevOps/test/go/gotest.sh) — Manages `.env` creation, downloads modules (`go mod download`), and executes `go test -v ./...`.
  - **`test/mvn/`**:
    - [`test/mvn/action.yaml`](file:///Users/i/work/KAnggara/DevOps/test/mvn/action.yaml) — Sets up JDK (Temurin 21).
    - [`test/mvn/mvntest.sh`](file:///Users/i/work/KAnggara/DevOps/test/mvn/mvntest.sh) — Injects application properties and executes `./mvnw test` / `mvn test`.
  - **`test/node/`**:
    - [`test/node/action.yaml`](file:///Users/i/work/KAnggara/DevOps/test/node/action.yaml) — Sets up Node.js runtime (`actions/setup-node@v4`), supports custom `node-version`, `.env` injection, and configurable `test_command`.
    - [`test/node/nodetest.sh`](file:///Users/i/work/KAnggara/DevOps/test/node/nodetest.sh) — Manages `.env` creation, resolves dependencies via `npm ci` / `npm install`, and executes the designated test command.
- **Dependencies**: Bun runtime, Go (`actions/setup-go`), Java Temurin, Node.js (`actions/setup-node`), Maven.
- **Consumers**: PR validation workflows (`.github/workflows/bunTest.yaml`, `.github/workflows/goTest.yaml`, `.github/workflows/maventest.yaml`, `.github/workflows/nodeTest.yaml`).

---

## 7. `version/`
- **Responsibility**: Git-based semantic version calculation using GitVersion toolset.
- **Entry / Key Files**:
  - [`version/action.yaml`](file:///Users/i/work/KAnggara/DevOps/version/action.yaml) — Fetches git tags/history, runs `gittools/actions/gitversion/setup` & `execute`, writes version artifacts, and uploads via `actions/upload-artifact@v4.6.0`.
  - [`version/version.sh`](file:///Users/i/work/KAnggara/DevOps/version/version.sh) — Exports GitVersion environment variables (`ShortSha`, `FullSemVer`, `CommitDate`, `MajorMinorPatch`) into text files under `gitversion/`.
- **Dependencies**: `gittools/actions/gitversion@v3.1.1`, git unshallow history.
- **Consumers**: Tagging and release pipelines (`.github/workflows/version.yaml`, `.github/workflows/tagging.yaml`).

---

## 8. `action_test/`
- **Responsibility**: Integration and regression testbed containing sample target projects (sample Maven Spring Boot/Java project, sample Bun application, sample Go application, sample Node.js application).
- **Entry / Key Files**:
  - [`action_test/mvn/pom.xml`](file:///Users/i/work/KAnggara/DevOps/action_test/mvn/pom.xml) — Test Java project.
  - [`action_test/bun/package.json`](file:///Users/i/work/KAnggara/DevOps/action_test/bun/package.json) — Test Bun project with test specs.
  - [`action_test/go/go.mod`](file:///Users/i/work/KAnggara/DevOps/action_test/go/go.mod) — Test Go project with test specs.
  - [`action_test/node/package.json`](file:///Users/i/work/KAnggara/DevOps/action_test/node/package.json) — Test Node.js project with native test specs.
- **Consumers**: Local test harness for validating GitHub Actions in CI workflows.
