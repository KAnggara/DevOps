## Usage

```yaml
- uses: KAnggara/DevOps/test/bun@main
  with:
    path: "./"
    bun_version: "latest"
    dot_env: ${{ secrets.DOTENV }}
```

## Inputs
- `path`: Path to the Bun project (default: `./`).
- `bun_version`: Bun version to use (default: `latest`).
- `dot_env`: Environment variables for the test.
