# AGENTS.md — DevOps Workspace Guidelines

Welcome to the `KAnggara/DevOps` repository! This document serves as the high-level guide for AI agents and human contributors working on this codebase.

---

## 1. Baseline Project Context & Documentation

Detailed architectural and design documents are centralized in [`.context/`](file:///Users/i/work/KAnggara/DevOps/.context/):
- [**`CODEBASE_MAP.md`**](file:///Users/i/work/KAnggara/DevOps/.context/CODEBASE_MAP.md) — Comprehensive module navigation, inputs, dependencies, and key files.
- [**`ARCHITECTURE.md`**](file:///Users/i/work/KAnggara/DevOps/.context/ARCHITECTURE.md) — Mermaid component flow, request lifecycles, and error boundaries.
- [**`PROJECT_CONTEXT.md`**](file:///Users/i/work/KAnggara/DevOps/.context/PROJECT_CONTEXT.md) — Project boundaries, actors, glossary, and constraints.
- [**`DECISIONS.md`**](file:///Users/i/work/KAnggara/DevOps/.context/DECISIONS.md) — Architecture Decision Records (ADRs). Append-only.
- [**`TODO.md`**](file:///Users/i/work/KAnggara/DevOps/.context/TODO.md) — Technical debt, known issues, and future improvements.

---

## 2. Repository Philosophy & Code Standards
- **Composite Actions First**: Maintain reusable logic as GitHub Composite Actions with bash script execution.
- **Fail-Fast & Safe Shell Scripts**: Always use `set -euo pipefail` or `set -eu`. Intercept errors with explicit `abort()` functions.
- **Sensitive Cleanups**: Always clean up sensitive tokens and Docker auth via `if: always()` hooks.
- **Conventional Commits**: Write commits using `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`, `ci:`.
- **Token Efficiency**: Always use RTK proxy commands (`rtk git ...`) for git/shell commands when available.
