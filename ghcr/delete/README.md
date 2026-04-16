# Delete Image From Registry

# Action Step

1. Login to GHCR with `GH_TOKEN`
2. Validate `ORG_NAME` and `REPO_NAME`
3. check `KEEP_LATEST` is set, default will keep last 6 images
4. check `RETENTION_DAYS` is set, default will keep last 60 days
5. Check Repo is Org or Username
6. 

## Usage

```yaml
- uses: KAnggara/DevOps/ghcr/delete@main
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    keep_release: "5"
    keep_non_release: "2"
```

## Inputs
- `github_token`: GitHub token with registry access (required).
- `keep_release`: Number of release images to keep (default: `5`).
- `keep_non_release`: Number of non-release images to keep (default: `2`).
