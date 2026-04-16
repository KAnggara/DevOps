# Docker Build Action

GitHub Action for building and pushing Docker images.

## Usage

```yaml
- uses: KAnggara/DevOps/dockerbuild@main
  with:
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
    registry: "ghcr.io"
    image_name: "my-app"
    path: "./"
    dockerfile_path: "./Dockerfile"
```

## Inputs
- `username`: Registry username (required).
- `password`: Registry password/token (required).
- `registry`: Target registry, e.g., `ghcr.io` (required).
- `image_name`: Image name (default: repository name).
- `path`: Build context path (default: `./`).
- `dockerfile_path`: Path to Dockerfile (default: `./Dockerfile`).
