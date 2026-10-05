# DevOps Actions & Workflows

A comprehensive collection of reusable GitHub Composite Actions and orchestration scripts designed to streamline DevOps processes such as building, testing, containerizing, versioning, cleaning, and deploying applications across multi-runtime environments (Java/Maven, TypeScript/Bun, Go, Node.js, Docker/Podman, GHCR, and Kubernetes).

---

## Repository Structure

- [**`dockerbuild/`**](./dockerbuild/README.md): Build and push container images using Docker BuildKit with inline caching and dynamic branch tagging.
- [**`ghcr/`**](./ghcr/README.md): GitHub Container Registry utilities for automated package version pruning and image hygiene.
- [**`helmDeploy/`**](./helmDeploy/README.md): Automated Kubernetes GitOps-style deployments using Helm driven by Git diff detection.
- [**`lcov/`**](./lcov/README.md): Code coverage processing and HTML report generation using LCOV and Bun.
- [**`mavenbuild/`**](./mavenbuild/README.md): Maven Java application packaging, secret property injection, and artifact archiving.
- [**`test/`**](./test/README.md): Unified testing suite for various languages and runtimes:
  - [`test/bun`](./test/bun/README.md): TypeScript/JavaScript testing with Bun runtime.
  - [`test/go`](./test/go/README.md): Go testing with module downloads and coverage profiling.
  - [`test/mvn`](./test/mvn/README.md): Java testing with Maven and application properties setup.
  - [`test/node`](./test/node/README.md): Node.js testing with native test runner or custom test commands.
- [**`version/`**](./version/README.md): Automated semantic versioning calculation via GitVersion.
- [**`action_test/`**](./action_test/README.md): Test harness and sample applications validating all composite actions.

---

## Action Catalog & Usage Examples

### 1. Docker Build & Push (`dockerbuild`)
Builds container images using BuildKit, leverages registry layer caching (`--cache-from latest`), and applies dynamic tags (`release-*` on main, `sit-*` on feature branches, `dev-*` otherwise). Includes automatic credential cleanup.

```yaml
- name: Build and Push Docker Image
  uses: KAnggara/DevOps/dockerbuild@main
  with:
    path: "./"
    dockerfile_path: "./Dockerfile"
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
    registry: "ghcr.io"
    image_name: ${{ github.repository }}
    tag_strategy: "date" # 'date' (release-YYYYMMDD-HHMM) or 'run_number' (release-123)
```

---

### 2. GHCR Image Pruner (`ghcr/delete`)
Deletes obsolete container image versions from GitHub Container Registry (GHCR) based on retention policies.

```yaml
- name: Prune Old GHCR Images
  uses: KAnggara/DevOps/ghcr/delete@main
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    keep_release: "5"      # Retain latest 5 release/prod images
    keep_non_release: "2"  # Retain latest 2 dev/sit images
```

---

### 3. Kubernetes Helm Deploy (`helmDeploy`)
Evaluates Git diffs in `apps/*.yaml`, computes semantic versioning via GitVersion, updates `Chart.yaml`, and executes atomic Helm rollouts to Kubernetes.

```yaml
- name: Deploy to Kubernetes via Helm
  uses: KAnggara/DevOps/helmDeploy@main
  with:
    kubeconfig: ${{ secrets.KUBECONFIG_BASE64 }}
```

---

### 4. LCOV Code Coverage Reporter (`lcov`)
Installs LCOV, compiles coverage information into HTML reports using `genhtml`, and verifies reports with Bun.

```yaml
- name: Generate LCOV HTML Report
  uses: KAnggara/DevOps/lcov@main
  with:
    coverage-files: "coverage/lcov.info"
    out-dir: "coverage"
    working-dir: "./"
```

---

### 5. Maven Build & Artifact Archiving (`mavenbuild`)
Sets up Eclipse Temurin JDK, injects confidential application properties, builds the package via Maven Wrapper or local Maven, and archives the `.jar` to GitHub Actions artifacts.

```yaml
- name: Build Maven Application
  uses: KAnggara/DevOps/mavenbuild@main
  with:
    path: "./"
    java-version: "21"
    distribution: "temurin"
    application-properties: ${{ secrets.APP_PROPERTIES }}
    override-properties: "true"
    retention-days: "7"
```

---

### 6. Testing Actions (`test/`)

#### a. Bun Test (`test/bun`)
Sets up Bun runtime, handles `.env` configuration, and executes test suites.

```yaml
- name: Run Bun Tests
  uses: KAnggara/DevOps/test/bun@main
  with:
    path: "./"
    bun_version: "latest"
    dot_env: ${{ secrets.BUN_DOTENV }}
```

#### b. Go Test (`test/go`)
Sets up Go environment, injects `.env` configuration, downloads module dependencies, and runs tests with optional coverage profiling.

```yaml
- name: Run Go Tests
  uses: KAnggara/DevOps/test/go@main
  with:
    path: "./"
    go-version: "1.23.x"
    dot_env: ${{ secrets.GO_DOTENV }}
    coverage: "true" # Generates coverage.out
```

#### c. Maven Test (`test/mvn`)
Sets up JDK, applies test properties to `application.properties`/`application.yaml`, and runs `mvn test`.

```yaml
- name: Run Maven Tests
  uses: KAnggara/DevOps/test/mvn@main
  with:
    path: "./"
    java-version: "21"
    distribution: "temurin"
    application-properties: ${{ secrets.TEST_APPLICATION_PROPERTIES }}
    override-properties: "true"
```

#### d. Node.js Test (`test/node`)
Sets up Node.js, manages `.env` configuration, installs dependencies with `npm ci` or `npm install`, and runs native or custom test scripts.

```yaml
- name: Run Node.js Tests
  uses: KAnggara/DevOps/test/node@main
  with:
    path: "./"
    node-version: "20.x"
    dot_env: ${{ secrets.NODE_DOTENV }}
    test_command: "npm test" # e.g. 'npm test', 'node --test', or 'npm run test:ci'
```

---

### 7. Git Versioning (`version`)
Unshallows Git history, executes GitVersion, extracts version tokens into `gitversion/` artifacts, and uploads them for subsequent pipeline stages.

```yaml
- name: Calculate Semantic Version
  uses: KAnggara/DevOps/version@main
  with:
    path: "./"
```

---

## License

This repository is licensed under the [MIT License](./LICENSE).
