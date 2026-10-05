## Usage

```yaml
- uses: KAnggara/DevOps/test/go@main
  with:
    path: "./"
    go-version: "1.23.x"
    dot_env: ${{ secrets.DOTENV }}
    coverage: "false"
```

## Inputs
- `path`: Path to the Go project (default: `./`).
- `go-version`: Go version to use (default: `1.23.x`).
- `dot_env`: Environment variables for the test (writes to `.env`).
- `coverage`: Whether to generate a test coverage profile (`coverage.out`) (default: `false`).
