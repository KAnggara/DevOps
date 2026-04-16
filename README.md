# DevOps Actions & Workflows

This repository contains a collection of reusable GitHub Actions and scripts designed to streamline DevOps processes such as building, testing, versioning, and deploying applications.

## Repository Structure

- [**`dockerbuild/`**](./dockerbuild/README.md): Build and push Docker images.
- [**`ghcr/`**](./ghcr/README.md): GitHub Container Registry utilities.
- [**`helmDeploy/`**](./helmDeploy/README.md): Kubernetes deployment using Helm.
- [**`lcov/`**](./lcov/README.md): LCOV coverage reporting.
- [**`mavenbuild/`**](./mavenbuild/README.md): Maven project builds.
- [**`test/`**](./test/README.md): Unified testing actions (Bun, Maven).
- [**`version/`**](./version/README.md): Automated version management.
- [**`action_test/`**](./action_test/README.md): Sample projects for testing these actions.

## CI/CD Pipeline Steps

1. **Unit Test**: Run tests across different runtimes.
2. **Build**: Compile and package applications.
3. **Artifact Registry**: Upload builds to GitHub Registry.
4. **Security Scan**: Scan for vulnerabilities (SAST/DAST).
5. **Docker Build**: Containerize applications.
6. **Deployment**: Deploy to Kubernetes/Cloud environments.

## How to Use

Each directory contains an `action.yaml` file. You can reference these actions in your workflows using the following syntax:

```yaml
jobs:
  build:
    steps:
      - uses: KAnggara/DevOps/mavenbuild@main
```
