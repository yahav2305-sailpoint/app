# app

## Running the app locally for debugging purposes

1. Start devcontainer: cmd/ctrl + shift + P -> Search for `>Dev containers: Reopen in container`
1. In the terminal run `python3 app/app.py` or use your preffered debugging environment

## Running the app locally with Docker

1. Build the image: `docker build . -t <tag>`
1. Run the image: `docker run --rm -p <port>:<port> --env PORT=<port> <tag>`
