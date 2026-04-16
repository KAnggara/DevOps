# LCOV Coverage Action

GitHub Action for generating and processing LCOV coverage reports.

## Usage

```yaml
- uses: KAnggara/DevOps/lcov@main
  with:
    coverage-files: "coverage/lcov.info"
    out-dir: "coverage"
    working-dir: "./"
```

## Inputs
- `coverage-files`: The coverage files to scan (default: `coverage/lcov.info`).
- `out-dir`: The output directory for HTML (default: `coverage`).
- `working-dir`: The source root directory.
