# Project Context & Domain Overview

## 1. Project Purpose
The `DevOps` repository provides a centralized collection of modular, production-ready GitHub Composite Actions and orchestration scripts. It streamlines application pipelines across building, testing, containerizing, versioning, cleaning, and deploying services in Kubernetes and GitHub Container Registry.

---

## 2. System Boundaries
- **In-Scope**:
  - Reusable GitHub Actions for Java (Maven), TypeScript (Bun), Docker/Podman, Helm, LCOV, GitVersion, and GHCR pruning.
  - Test suites and mock sample applications (`action_test/`) to validate CI actions before publishing.
  - Standardized shell scripts with credential isolation and cleanup hooks.
- **Out-of-Scope**:
  - Direct hosting of production microservices.
  - Infrastructure provisioning (Terraform / cloud provider account creation).

---

## 3. Main Actors
- **Developer / DevOps Engineer**: Authors, maintains, tests, and publishes action releases.
- **Downstream CI/CD Workflows**: Caller repositories consuming actions via `uses: KAnggara/DevOps/<action>@<version>`.
- **GitHub Actions Runners**: Execution environments processing jobs.

---

## 4. Domain Glossary
- **Composite Action**: A GitHub Action combining multiple workflow steps inside a single yaml file.
- **GitVersion**: Tool for calculating semantic versioning based on Git history, tags, and commit messages.
- **BuildKit**: Next-generation Docker build subsystem providing parallel execution, cache mounts, and inline cache export.
- **GHCR**: GitHub Container Registry (`ghcr.io`).

---

## 5. External Integrations
- **GitHub Actions Runner Environment**: Default Linux (`ubuntu-latest`).
- **GitHub Container Registry (ghcr.io)**: Target image registry and version pruning via GitHub REST API.
- **Kubernetes**: Target cluster managed via `kubectl` and `helm`.
- **GitTools / GitVersion**: Automated semantic version determination.

---

## 6. Runtime Environment & Constraints
- **Shell**: Bash with `set -euo pipefail`.
- **Java**: Default JDK 21 (Eclipse Temurin distribution).
- **JavaScript/TypeScript**: Bun runtime (`oven-sh/setup-bun@v2`).
- **Containers**: Docker with BuildKit enabled (`DOCKER_BUILDKIT=1`).

---

## 7. Coding & Delivery Standards
- Conventional Commits (`feat`, `fix`, `refactor`, `chore`, `docs`, `ci`).
- Cleanup handlers (`if: always()`) for sensitive credential de-authentication.
- Zero external runtime dependency additions where native shell / CLI suffices.
