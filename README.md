# app

Source code, Dockerfile, and CI pipeline for **Linker** — a small Python URL shortener.

## Running locally (Python)

Requires Python 3.11+.

```sh
pip install -r app/requirements.txt
python app/app.py
```

The app listens on `http://localhost:8080` by default. Override with the `BASE_URL` environment variable:

```sh
BASE_URL=http://my-host:9000 python app/app.py
```

### Using the devcontainer

Open the repo in VS Code, then run **Dev Containers: Reopen in Container** (`Ctrl/Cmd + Shift + P`). The container has all dependencies pre-installed. Run `python app/app.py` in the integrated terminal, or use the VS Code debugger.

## Running locally with Docker

```sh
# Build
docker build -t linker:local .

# Run
docker run --rm -p 8080:8080 -e BASE_URL=http://localhost:8080 linker:local
```

Try it:

```sh
# Shorten a URL
curl -s -X POST http://localhost:8080/shorten \
  -H 'Content-Type: application/json' \
  -d '{"url": "https://example.com"}' | jq

# Follow the short URL
curl -v http://localhost:8080/<slug>

# Health check
curl http://localhost:8080/health

# Stats
curl http://localhost:8080/stats
```

## Deploying to Kubernetes

To deploy to a local cluster using the Helm chart and Argo CD, see [app-helm](https://github.com/yahav2305-sailpoint/app-helm).

## Image

Published to **GitHub Container Registry** at `ghcr.io/yahav2305-sailpoint/app`.

Multi-arch build (`linux/amd64` + `linux/arm64`). Available tags:

| Tag | Meaning |
| --- | --- |
| `latest` | Most recent commit merged to `main` |
| `sha-<git-sha>` | Exact build for a given commit |
| `v1.2.3` | Stable release |

## CI pipeline

| Trigger | Workflow | What happens |
| --- | --- | --- |
| Push to any branch | `dev.yaml` | Runs tests (Dockerfile lint) |
| PR to `main` | `pull-request.yaml` | Runs tests → builds & pushes `sha-<pr-head-sha>` → Trivy vulnerability scan |
| Merge to `main` | `prod.yaml` | Promotes the PR image to `sha-<merge-sha>` and `latest` |
| Git tag pushed | `prod.yaml` | Tags the image with the semver tag; bumps `appVersion` in `app-helm` and creates a new chart version |

## Creating a release

1. Merge all desired changes to `main`.
1. Push a semver tag:

    ```sh
    git tag v1.2.3
    git push origin v1.2.3
    ```

1. CI promotes the Docker image to `v1.2.3` and automatically opens a commit in [app-helm](https://github.com/yahav2305-sailpoint/app-helm) that bumps `appVersion` and releases a new chart version.\
Permissions to the app-helm repo are handled using a PAT that can only edit the app-helm repo contents. That PAT is copied from the app-helm repo to the organization, and only the Github Actions of the app repo can access it.

## Container security

- **Multi-stage build** — dependencies are installed in an Alpine builder stage; only the compiled artifacts are copied to the runtime image.
- **Distroless runtime** (`gcr.io/distroless/python3-debian13:nonroot`) — no shell, no package manager, minimal attack surface.
- **Non-root** — runs as UID 65532 (`nonroot`).
- **SBOM** — a Software Bill of Materials is attached to every pushed image.
