# Maven Test Action

GitHub Action to run tests for Maven projects.

## Usage

```yaml
- uses: KAnggara/DevOps/test/mvn@main
  with:
    path: "./"
    java-version: "21"
    distribution: "temurin"
    application-properties: ${{ secrets.APP_PROPERTIES }}
```

## Inputs
- `path`: Path to the Maven project (default: `./`).
- `java-version`: Java version to use (default: `21`).
- `distribution`: Java distribution (default: `temurin`).
- `application-properties`: Content for `application.properties`.
- `override-properties`: Whether to override properties (default: `false`).
