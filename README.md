# Conduit Container

This project aims to containerize the conduit frontend and backend projects using docker compose, making it easy to connect and start the frontend and backend.

---

## Table of contents

- [Dependencies](#dependencies)
- [Quick start](#quick-start)
- [Structure](#structure)
- [Environments](#environments)
- [How it works](#how-it-works)

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

    - Or use your GUI to create a file in project root location, named `.env` and copy past the content of [template.env](./template.env) to it.

    > [!NOTE] the [template.env](./template.env) already contains the default values for a local setup.

    Replace the values in `.env` to your needs. See [Environments](#environments) for more details.

1. **Start the project using `docker-compose`:**

    ```bash
    docker-compose up --build
    ```

    > [!NOTE] See [How it works](#how-it-works) for more details about the build and start process.

If everything worked alright you can access conduit frontend and backend in your browser:

- conduit-fronted is set by default to <http://localhost:8282>
- conduit-backend is set by default to <http://localhost:8889>

---

## Structure

- [conduit-backend](./conduit-backend): Git submodule to conduit backend source code.
- [conduit-frontend](./conduit-frontend): Git submodule to conduit frontend source code.
- [backend.Dockerfile](./backend.Dockerfile): Docker file to build docker container for the conduit backend.
- [docker-compose.yaml](./docker-compose.yaml): Docker compose file to build and run conduit frontend and backend containers.
- [frontend.Dockerfile](./frontend.Dockerfile): Docker file to build docker container for the conduit frontend.
- [Git Submodule.md](./Git%20Submodule.md): Guide how to work with Git submodules.
- [template.env](./template.env): Contains default values for environments.

## Environments

> [!NOTE] For Django specific variables see [Django Settings Docs](https://docs.djangoproject.com/en/dev/ref/settings/) for more info.

| Name | Type | Description |
| :--- | :--: | ----------: |
| API_URL | URL | The URL to backend api, used by frontend in the [API Interceptor](./conduit-frontend/src/app/core/interceptors/api.interceptor.ts) |
| DJANGO_SECRET_KEY | string |  This is used to provide cryptographic signing. |
| DJANGO_DEBUG | bool | Never deploy a site into production with DEBUG turned on. |
| DJANGO_ALLOWED_HOSTS | list | A list of strings representing the host/domain names that this Django site can serve. |
| CORS_ORIGIN_WHITELIST | tulpe | A list of origins that are authorized to make cross-site HTTP requests. See [django-cors-headers](https://pypi.org/project/django-cors-headers/) for more details. |

---

## How it works

The entire build and run process is managed by the [docker-compose.yaml](./docker-compose.yaml) file.

It defines two services and a volume:

- **conduit-frontend** service: Builds and starts the conduit frontend application.
- **conduit-backend** service: Builds and starts the conduit backend application.
- **db** volume: Bound to the conduit backend application's database.

### **conduit-frontend** service

This services sets following configurations:

- Sets build context to the git submodule [conduit-frontend](./conduit-frontend/). This contains the frontend source code of conduit, that is written in Angular.

- Uses this [frontend.Dockerfile](./frontend.Dockerfile) file as the `dockerfile`. This has two build stages:

    1. **build** stage: Uses `node:20` as base image.

        - Has an `API_URL` argument that defines the backend url to be set in the frontend application environments. By default this is set to <http://localhost:8000>.

        - The `RUN` replaces the `{{API_URL}}` to this value into [environment.prod.ts](./conduit-frontend/src/environments/environment.prod.ts).

        - Then installs the frontend dependencies and finally builds the production frontend.

    1. **prod** stage: Uses `nginx:alpine` as base image.

        - Copies the build artefacts from **build** stage `/app/dist/angular-conduit` to nginx exposed location `/usr/share/nginx/html`.

        - Exposes container port `80`.

        - The `CMD` starts `nginx` services and collects the application logs to `/var/log/container_logs/container.log 2>&1`.

- Sets `depends_on` to **conduit-backend**  services.
- Binds the host port `8282` to container port `80`.
- Sets `restart` to `unless-stopped`.
- Binds the host `./logs/frontend` location to container `/var/log/container_logs` location to persist application logs.
- Sets `logging` limits log file size to 10 MB per file and retains up to 3 files, ensuring logs don't consume excessive disk space.

### **conduit-backend** service

This services sets following configurations:

- Sets build context to the git submodule [conduit-backend](./conduit-backend/). This contains the backend source code of conduit, that is written in Django.

- Uses this [backend.Dockerfile](./backend.Dockerfile) file as the `dockerfile`. This has one build stage:

    1. Uses `python:3.6-slim` as base image.
    1. The `RUN` installs the backend dependencies.
    1. Exposes container port `8000`.
    1. The `CMD` runs the django `makemigrations`, `migrate` and `runserver 0.0.0.0:8000` then collects the application logs to `/var/log/container_logs/container.log 2>&1`.

- Binds the host port `8889` to container port `8000`.
- Sets `restart` to `unless-stopped`.
- Binds the host `./logs/backend` location to container `/var/log/container_logs` location, to persist application logs.
- Binds the **db** volume to conduit backend database location.

    > [!NOTE] the database location is set in the django settings file [here](./conduit-backend/conduit/settings.py).

- Sets `logging` limits log file size to 10 MB per file and retains up to 3 files, ensuring logs don't consume excessive disk space.
- Sets `env_file` to `.env` file. Necessary to load environments ito the backend container.

> [!IMPORTANT] **Changes to consider**

> If you required to change the port bindings in `docker-compose-yaml` you should also change them in your `.env` file accordantly.

The port binding in `conduit-frontend` service is tight to `CORS_ORIGIN_WHITELIST` in `.env`. They have to match, otherwise the browser will not allow to make http requests.

The port binding in `conduit-backend` service is tight to `API_URL` in `.env`. They have to match, otherwise the frontend will make request to wrong endpoint.
