# Maven Build Action

This folder contains the GitHub Action for building Maven projects.

## Contents
- `action.yaml`: Action definition.
- `mavenbuild.sh`: Script to execute the Maven build.

## Usage

```yaml
- uses: KAnggara/DevOps/mavenbuild@main
  with:
    path: "./"
    java-version: "21"
    distribution: "temurin"
    application-properties: ${{ secrets.APP_PROPERTIES }}
    retention-days: "7"
```

## Inputs
- `path`: Path to the Maven project (default: `./`).
- `java-version`: Java version to use (default: `21`).
- `distribution`: Java distribution (default: `temurin`).
- `application-properties`: Content for `application.properties` (from secrets).
- `override-properties`: Whether to override properties (default: `false`).
- `retention-days`: Artifact retention period (default: `7`).
