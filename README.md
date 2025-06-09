# Conduit Container

This project containerizes the Conduit frontend and backend using Docker Compose, making it easy to connect and start both components.

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

    > [!NOTE]
    > Use the `--recursive` argument to automatically update the `conduit-frontend` and `conduit-backend` submodules. For more on Git Submodules, see this [guide](./Git%20Submodule.md).

    ```bash
    git clone --recursive https://github.com/mihaiandreineacsu/conduit.git && cd conduit
    ```

1. **Create dot env file**

    - Using CLI:

        ```bash
        cat template.env > .env
        ```

    - Or manually create a `.env` file in the project root and copy the contents of [template.env](./template.env) into it.

    > [!NOTE]
    > The [template.env](./template.env) contains default values for local setup. Adjust these values as needed. See [Environments](#environments) for more details.

1. **Start the project with Docker Compose:**

    ```bash
    docker-compose -f docker-compose.dev.yaml up --build
    ```

    > [!NOTE]
    > See [Usage](#usage) for more details about the build and start process.

Access the Conduit frontend and backend in your browser:

- Frontend: <http://localhost:8080>
- Backend: <http://localhost:8000>

---

## Structure

- [conduit-backend](./conduit-backend): Git submodule for the backend source code.
- [conduit-frontend](./conduit-frontend): Git submodule for the frontend source code.
- [backend-entrypoint.sh](./backend-entrypoint.sh): Entrypoint for the backend container.
- [backend.Dockerfile](./backend.Dockerfile): Dockerfile for building the backend container.
- [docker-compose.dev.yaml](./docker-compose.dev.yaml): Docker Compose file for local development.
- [docker-compose.yaml](./docker-compose.yaml): Docker Compose file for production.
- [frontend-entrypoint.sh](./frontend-entrypoint.sh): Entrypoint for the frontend container.
- [frontend.Dockerfile](./frontend.Dockerfile): Dockerfile for building the frontend container in production.
- [frontend.dev.Dockerfile](./frontend.dev.Dockerfile): Dockerfile for building the frontend container in development.
- [Git Submodule.md](./Git%20Submodule.md): Guide for working with Git submodules.
- [nginx.config](./nginx.config): Nginx configuration for the frontend.
- [template.env](./template.env): Default environment variables.

---

## Usage

The local development process is managed by [docker-compose.dev.yaml](./docker-compose.dev.yaml), defining two services and a volume:

- **conduit-frontend** Builds and starts the frontend application.
- **conduit-backend** Builds and starts the backend application.

### Environments

> [!NOTE]
> For Django-specific variables see the [Django Settings Docs](https://docs.djangoproject.com/en/dev/ref/settings/).

| Name | Type | Description |
| :--- | :--: | ----------: |
| FRONTEND_URL | URL | The frontend URL, used by the backend in [django settings](./conduit-backend/conduit/settings.py). |
| FRONTEND_PORT | int | The frontend port, used by the backend in [django settings](./conduit-backend/conduit/settings.py). |
| BACKEND_URL | URL | The backend API URL, used by the frontend in the [API Interceptor](./conduit-frontend/src/app/core/interceptors/api.interceptor.ts). |
| BACKEND_PORT | int | The backend API port, used by the frontend in the [API Interceptor](./conduit-frontend/src/app/core/interceptors/api.interceptor.ts). |
| DJANGO_SECRET_KEY | string | Used for cryptographic signing. |
| DJANGO_DEBUG | bool | Do not deploy with **DEBUG** turned on. |
| DJANGO_SUPERUSER_EMAIL | string | Email for the Django admin. |
| DJANGO_SUPERUSER_USERNAME | string | Username for the Django admin. |
| DJANGO_SUPERUSER_PASSWORD | string | Password for the Django admin. |

---

### Deployment

Deployment is defined in [.github/workflows/deployment.yaml](./.github/workflows/deployment.yaml).

It triggers on tags following the pattern `'v*.*.*'`.

Steps executed when triggered:

1. Log into GitHub Container Registries.
1. Build and push the frontend to GitHub Container Registries.
1. Build and push the backend to GitHub Container Registries.
1. Create a `.env` file.
1. Securely copy [docker-compose.yaml](./docker-compose.yaml) and the `.env` file to the Cloud VM.
1. Log into the Cloud VM and release Conduit.

### Required Github Repository Secrets

For **Login to GitHub Container Registries**:

- **GITHUB_TOKEN** : Personal Access Token for GitHub Container Registries.

For **Build and Push Conduit Frontend**:

- **BACKEND_URL**: Backend API URL.
- **BACKEND_PORT**: Backend API port.

For **Create .env File**:

- All environments variables defined in [template.env](./template.env).

For **Login to Cloud VM and Release Conduit**:

- **REMOTE_USER**: SSH username.
- **REMOTE_HOST**: SSH server address.
- **REMOTE_SSH_KEY**: SSH private key.
