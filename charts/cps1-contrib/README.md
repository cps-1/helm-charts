# CPS1 Contrib

CPS1 Contrib is a curated collection of Packages, Resources and Templates for the [CPS1 Platform](https://cps1.tech).

For instructions on how to install, please refer to: https://helm.cps1.tech

For more information, please refer to our documentation: https://docs.cps1.tech

## Packages

| Package | Supported versions                          | Extra Tools                      |
|----------|-----------------------------------|----------------------------------|
| ![Python](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg) **Python** | 3.10, 3.11, 3.12, 3.13                   | uv, pip, pipx, virtualenv, poetry           |
| ![Dotnet](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dotnetcore/dotnetcore-original.svg) **.NET Core** | 8.0, 9.0                | dotnet CLI                 |
| ![NodeJS](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nodejs/nodejs-original.svg) **NodeJS** | 20, 22, 24                    | npm, yarn, nvm                    |
| ![Rust](https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/rust/rust-original.svg) **Rust** | stable       | cargo, rustup, clippy             |
| ![Java](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg) **Java** | 17, 21 (Temurim)                    | Maven, Gradle, SDKMAN             |

## Resouces

| Resource | Versions                  |
|----------|---------------------------|
| ![MariaDB](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mariadb/mariadb-original.svg) **MariaDB** | 10.6, 10.11, 11.4, 11.8          |
| ![PostgreSQL](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg) **PostgreSQL** | 14, 15, 16, 17              |
| ![Redis](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg) **Redis** | 7.2, 7.4, 8.0                        |

## Templates

We ship templates for each supported language, but they are not installed by default.

You must explicit include what templates you want installed using the `includeTemplates` parameter.

```
helm install cps1-contrib cps1/cps1-contrib --set includeTemplates={nodejs,python}
```

# Extending CPS1

## Developing packages

To work on CPS1 packages, run the package script inside a base image for testing:

```
docker run -ti -v ./scripts:/scripts ghcr.io/cps-1/base-image:latest /bin/bash
```

## Building a template

1. Set up a local registry

Create a Docker network and start a local registry:

```
docker network create registry

docker run -d --restart=always --network registry --name cps1-registry registry:2
```

2. Run the `template-builder.sh` script

Execute the script inside a Buildah container:

```
docker run --network registry --privileged -v .:/scripts -ti quay.io/buildah/stable /bin/bash /scripts/template-builder.sh
```

To customize the build, set environment variables before running the script:

```
docker run --network registry --privileged -e TEMPLATE_NAME=supper-app -v .:/scripts -ti quay.io/buildah/stable /bin/bash /scripts/template-builder.sh
```

For a complete list of available variables, refer to the `template-builder.sh` script.
