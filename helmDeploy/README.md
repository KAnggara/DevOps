# Helm Deploy Action

GitHub Action for deploying applications to Kubernetes using Helm.

## Usage

```yaml
- uses: KAnggara/DevOps/helmDeploy@main
  with:
    kubeconfig: ${{ secrets.KUBECONFIG_BASE64 }}
```

## Inputs
- `kubeconfig`: Base64 encoded KUBECONFIG file (required).
