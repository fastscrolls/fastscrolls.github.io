# Installation Guide

This page builder requires the following dependencies:

- `awk` (usually pre-installed on Linux systems)
- `jq` (JSON processor)
- `make` (build automation)
- `curl` (HTTP client)
- `sed` (stream editor)
- `sh` (shell, usually pre-installed)

## Ubuntu/Debian

```bash
sudo apt-get update
sudo apt-get install jq make curl
```

## macOS (using Homebrew)

```bash
brew install jq make curl
```

## Fedora/RHEL

```bash
sudo dnf install jq make curl
```

After installing the dependencies, you can build pages by running:

```bash
make
```

The generated HTML files will be in the `dist` directory. 