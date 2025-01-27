# Contributing to Nodes Tree Visualizer

- [Open Package](#open-package)
- [Lint Package](#lint-package)
- [Creating Releases](#creating-releases)

## Open Package

> The file header comment template will also be installed.

```
make open
```

## Lint Package

> SwiftLint violations are visible in Xcode as well.

To run SwiftLint from the command line:

```
make lint
```

To run analysis rules:

```
make analyze
```

## Creating Releases

Releases are made [on the GitHub website](https://github.com/Tinder/Nodes-Tree-Visualizer/releases/new).

In all of the following steps, `X.X.X` is a placeholder to be substituted with the actual semantic version for the release.

- Enter a semantic version as the new tag (__WITHOUT__ `v` prefix)
- Set the `main` branch as the target (it should be the default)
- Enter the release title formatted as `Nodes-Tree-Visualizer vX.X.X` (__WITH__ `v` prefix)
- Click on `Generate release notes`
- Leave `Set as a pre-release` unchecked
- Leave `Set as the latest release` checked
- Click `Publish release`
