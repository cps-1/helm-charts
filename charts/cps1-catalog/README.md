# CPS1 Catalog

CPS1 Catalog is a curated collection of Packages, Resources and Templates for the [CPS1 Platform](https://cps1.tech).

For instructions on how to install, please refer to: https://helm.cps1.tech

For more information, please refer to our documentation: https://docs.cps1.tech

## Packages

| Package | Supported versions                          | Extra Tools                      |
|----------|-----------------------------------|----------------------------------|
| ![Python](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg) **Python** | 3.10, 3.11, 3.12, 3.13, 3.14                   | uv, pip, pipx, virtualenv, poetry           |
| ![Dotnet](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dotnetcore/dotnetcore-original.svg) **.NET Core** | 8.0, 9.0                | dotnet CLI                 |
| ![NodeJS](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nodejs/nodejs-original.svg) **NodeJS** | 20, 22, 24                    | npm, yarn, nvm                    |
| ![Rust](https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/rust/rust-original.svg) **Rust** | stable       | cargo, rustup, clippy             |
| ![Java](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg) **Java** | 17, 21 (Temurim)                    | Maven, Gradle, SDKMAN             |

## Resouces

| Resource | Versions                  |
|----------|---------------------------|
| ![MariaDB](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mariadb/mariadb-original.svg) **MariaDB** | 10.6, 10.11, 11.4, 11.8, 12.1          |
| ![MySQL](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg) **MySQL** | 8.0, 8.4, 9.5           |
| ![PostgreSQL](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg) **PostgreSQL** | 14, 15, 16, 17, 18   |
| ![Redis](https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg) **Redis** | 7.4, 8.0, 8.2, 8.4            |

## Templates

We ship templates for each supported language, but they are not installed by default.

You must explicit include what templates you want installed using the `includeTemplates` parameter.

```
helm install cps1-catalog cps1/cps1-catalog --set includeTemplates={nodejs,python}
```

# Extending CPS1

## Developing packages

To work on CPS1 packages, run the package script inside a base image for testing:

```
docker run -ti -v ./scripts:/scripts ghcr.io/cps-1/base-image:latest /bin/bash
```

