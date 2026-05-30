# app

## Running the app locally for debugging purposes

1. Start devcontainer: cmd/ctrl + shift + P -> Search for `>Dev containers: Reopen in container`
1. In the terminal run `python3 app/app.py` or use your preffered debugging environment

## Running the app locally with Docker

1. Build the image: `docker build . -t <tag>`
1. Run the image: `docker run --rm -p <port>:<port> --env PORT=<port> <tag>`

## Running the app in a local Kubernertes cluster

To test how the app runs in a Kubernetes cluster, see the readme of this repo: [yahav2305-sailpoint/app-helm](https://github.com/yahav2305-sailpoint/app-helm/blob/main/README.md)

## Creating a new version

In order to create a new version of the app, make the required changes (by merging feature branches to main) and then create a new release with a tag that has a higher semver than the previous release.\
New versions will autoamtically be compiled to new docker images.

New Docker images will be automatically created for new pull requests, and promoted to main once the pull request is merged to main.\
Accordingly, when a commit in main is tagged, its Docker image will also be tagged with the same tag, and the new image tag will create a new helm chart version in the [yahav2305-sailpoint/app-helm](https://github.com/yahav2305-sailpoint/app-helm) repo.
