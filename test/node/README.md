## Usage

```yaml
- uses: KAnggara/DevOps/test/node@main
  with:
    path: "./"
    node-version: "20.x"
    dot_env: ${{ secrets.DOTENV }}
    test_command: "npm test"
```

## Inputs
- `path`: Path to the Node.js project (default: `./`).
- `node-version`: Node.js version to use (default: `20.x`).
- `dot_env`: Environment variables for the test (writes to `.env`).
- `test_command`: Test command to run (default: `npm test`).
