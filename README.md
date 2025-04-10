# Conduit Container

This project aims to containerize the conduit frontend and backend projects using docker compose, making it easy to connect and start the frontend and backend.

---

## Table of contents

- [Dependencies](#dependencies)
- [Quick start](#quick-start)
- [Structure](#structure)
- [Usage](#usage)
- [Environments](#environments)
- [Deployment](#deployment)

---

## Dependencies

- **Git**
- **Docker**
- **Docker Compose**

---

## Quick start

1. Download and navigate to Repository:

    > [!NOTE] Use the `--recursive` argument when cloning to also automatically update the `conduit-frontend` and `conduit-backend` git submodules. If you like to know more about working with Git Submodule, see this [guide](./Git%20Submodule.md).

    ```bash
    git clone --recursive https://github.com/mihaiandreineacsu/conduit.git && cd conduit
    ```

1. **Create dot env file**

    - Using cli bash:

        ```bash
        cat template.env > .env
        ```

    - Or use your GUI to create a file in project root location, named `.env` and copy paste the content of [template.env](./template.env) to it.

    > [!NOTE] the [template.env](./template.env) already contains the default values for a local setup.

    Replace the values in `.env` to your needs. See [Environments](#environments) for more details.

1. **Start the project using `docker-compose`:**

    ```bash
    docker-compose up --build
    ```

    > [!NOTE] See [Usage](#usage) for more details about the build and start process.

If everything worked alright you can access conduit frontend and backend in your browser:

- conduit-fronted is set by default to <http://localhost:8080>
- conduit-backend is set by default to <http://localhost:8000>

---

## Structure

- [conduit-backend](./conduit-backend): Git submodule to conduit backend source code.
- [conduit-frontend](./conduit-frontend): Git submodule to conduit frontend source code.
- [backend-entrypoint.sh](./backend-entrypoint.sh): The entrypoint file for conduit-backend container.
- [backend.Dockerfile](./backend.Dockerfile): Docker file to build docker container for the conduit backend.
- [docker-compose.yaml](./docker-compose.yaml): Docker compose file to build and run conduit frontend and backend containers.
- [frontend.Dockerfile](./frontend.Dockerfile): Docker file to build docker container for the conduit frontend.
- [Git Submodule.md](./Git%20Submodule.md): Guide how to work with Git submodules.
- [template.env](./template.env): Contains default values for environments.

## Usage

The entire build and run process is managed by the [docker-compose.yaml](./docker-compose.yaml) file.

It defines two services and a volume:

- **conduit-frontend** service: Builds and starts the conduit frontend application.
- **conduit-backend** service: Builds and starts the conduit backend application.
- **db** volume: Bound to the conduit backend application's database.

### Environments

> [!NOTE] For Django specific variables see [Django Settings Docs](https://docs.djangoproject.com/en/dev/ref/settings/) for more info.

| Name | Type | Description |
| :--- | :--: | ----------: |
| FRONTEND_URL | URL | The URL of frontend, used by backend in the [django settings](./conduit-backend/conduit/settings.py). |
| FRONTEND_PORT | int | The PORT of frontend, used by backend in the [django settings](./conduit-backend/conduit/settings.py). |
| BACKEND_URL | URL | The URL to backend api, used by frontend in the [API Interceptor](./conduit-frontend/src/app/core/interceptors/api.interceptor.ts). |
| BACKEND_PORT | int | The PORT to backend api, used by frontend in the [API Interceptor](./conduit-frontend/src/app/core/interceptors/api.interceptor.ts). |
| DJANGO_SECRET_KEY | string |  This is used to provide cryptographic signing. |
| DJANGO_DEBUG | bool | Never deploy a site into production with DEBUG turned on. |

---

### Deployment

The deployment is defined in [.github/workflows/deployment.yaml](./.github/workflows/deployment.yaml).
and triggers on `main` branch push.

Required Github Repository Secrets for deployment flow:

- **REMOTE_USER** : The username to connect per ssh.
- **REMOTE_HOST** : The server address to connect per ssh.
- **REMOTE_SSH_KEY** : The private ssh key to connect per ssh.
