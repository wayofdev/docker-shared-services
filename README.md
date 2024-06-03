<div align="center">
    <br>
    <a href="https://laravel-cycle-orm-adapter.wayof.dev" target="_blank">
        <picture>
            <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/wayofdev/.github/master/assets/logo.gh-dark-mode-only.png">
            <img width="400" src="https://raw.githubusercontent.com/wayofdev/.github/master/assets/logo.gh-light-mode-only.png" alt="WayOfDev Logo">
        </picture>
    </a>
    <br>
    <br>
</div>
<div align="center">
<a href="https://actions-badge.atrox.dev/wayofdev/docker-shared-services/goto"><img alt="Build Status" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fwayofdev%2Fdocker-shared-services%2Fbadge&style=flat-square&label=github%20actions"/></a>
<a href="https://github.com/wayofdev/docker-shared-services/tags"><img src="https://img.shields.io/github/v/tag/wayofdev/docker-shared-services?sort=semver&style=flat-square&label=version" alt="Latest Stable Version"></a>
<a href="LICENSE.md"><img src="https://img.shields.io/github/license/wayofdev/docker-shared-services.svg?style=flat-square&color=blue" alt="Software License"/></a>
<a href="https://github.com/wayofdev/docker-shared-services/commits/master"><img src="https://img.shields.io/github/commits-since/wayofdev/docker-shared-services/latest?style=flat-square" alt="Commits since latest release"></a>
<a href="https://discord.gg/CE3TcCC5vr" target="_blank"><img alt="Discord Link" src="https://img.shields.io/discord/1228506758562058391?style=flat-square&logo=discord&labelColor=7289d9&logoColor=white&color=39456d"></a>
<a href="https://x.com/intent/follow?screen_name=wayofdev" target="_blank"><img alt="Follow on Twitter (X)" src="https://img.shields.io/badge/-Follow-black?style=flat-square&logo=X"></a>
<br>
<br>
</div>

# Docker Shared Services

This repository provides a Docker-powered local development environment for Dockerized projects, compatible with macOS and Linux.

It includes a set of docker-compose files and [Træfik](https://traefik.io/) configuration with SSL support, backed by [mkcert](https://github.com/FiloSottile/mkcert), to enable running a local network with custom DNS provided by [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html). This setup facilitates developing microservices locally with access outside the Docker network.

## 🤔 Purpose

### → Simplifying Local Development

Developers often update their `/etc/hosts` file to direct traffic for `yourproject.docker` or `yourproject.domain.docker` to `127.0.0.1`. This approach has several drawbacks:

- Requires a configuration change every time you add or remove a project.
- Necessitates administrative access to make these changes.
- No SSL support for these domains.
- Requires forwarding Docker service ports to the host machine, leading to conflicts when multiple services use the same ports (80 or 443).
- Forces users to use cumbersome hostnames like `localhost:8800` for local projects.

For **Linux** and **macOS** users, **dnsmasq** provides a solution by eliminating the need to edit the hosts file for each project. Dnsmasq works well with [Traefik](https://traefik.io/), [mkcert](https://github.com/FiloSottile/mkcert), and **Docker**.

This repository configures Traefik to work with dnsmasq, providing a system-wide DNS solution for your microservices and enabling DNS and SSL features with local domains.

## 👏 Benefits for Team

### → Enhance Development Workflow

Integrating this Docker Shared Services project into your team's tech stack can significantly enhance your development workflow. This setup is compatible with a wide range of HTTP-based projects, including backend frameworks like Laravel, Symfony, or Spiral, frontend frameworks, and any other services that run in Docker and communicate over HTTP.

By standardizing the local network setup across different machines, your team can:

- Maintain consistency
- Reduce configuration work
- Resolve port conflicts
- Provide SSL support for local domains

This ensures smoother collaboration and boosts overall productivity.

<br>

If you **like/use** this project, please consider ⭐️ **starring** it. Thanks!

<br>

## 🚩 Requirements

- **macOS** Monterey+ or **Linux**
- **Docker** 26.0 or newer
  - [How To Install and Use Docker on Ubuntu 22.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)
- Installed [mkcert](https://github.com/FiloSottile/mkcert) binary in system
  - See full installation instructions in their official [README.md](https://github.com/FiloSottile/mkcert)
  - Quick installation on macOS: `brew install mkcert nss`
- ~~Installed and configured [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) daemon~~
  - ~~Can be installed and configured automatically via our [ansible-role-dnsmasq](https://github.com/wayofdev/ansible-role-dnsmasq) ansible role~~
  - [DNSMasq](https://thekelleys.org.uk/dnsmasq/doc.html) service now is shipped and configured with this repository.

<br>

## 🚀 Quick Start (macOS)

1. Install Homebrew (**optional** if not installed):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install `mkcert` and `nss`:**

   `mkcert` is a tool that creates locally-trusted development certificates, `nss` provides support of mkcert certificates in macOS.

   ```bash
   brew install mkcert nss
   ```

3. **Create shared projects Directory:**

   This repository should be run once per machine, so let's create a shared directory for this project:

   ```bash
   mkdir -p ~/projects/infra && cd ~/projects/infra
   ```

4. **Clone this repository:**

   ```bash
   git clone \
     git@github.com:wayofdev/docker-shared-services.git \
     ~/projects/infra/docker-shared-services && \
   cd ~/projects/infra/docker-shared-services
   ```

5. **Create `.env` file:**

   Generate a default `.env` file, which contains configuration settings for the project.

   ```bash
   make env
   ```

   Open this file and read the notes inside to make any necessary changes to fit your setup.

6. **Install root certificate** and generate default project certs:

   This step installs the root certificate into your system's trust store and generates default SSL certificates for your local domains, which are listed in the `.env` file, under variable `TLS_DOMAINS`.

   ```bash
   make cert-install
   ```

   Currently, on macOS you may need to enter password several times to allow mkcert to install root certificate.
   This is a one-time operation and details can be found in this upstream [issue](https://github.com/FiloSottile/mkcert/issues/415).

7. **Run this project:**

   Start the Docker services defined in the repository.

   ```bash
   make up
   ```

8. **Check that all Docker services are running:**

   ```bash
   make ps
   make logs
   ```

9. **Ping `router.docker` to check if DNS is working:**

   Ensure that the DNS setup is functioning correctly.

   ```bash
   ping router.docker
   ```

10. **Access Traefik dashboard:**

    Open [https://router.docker](https://router.docker)

At this point, you should have a working local development environment with DNS and SSL support for your projects.

<br>

## ⚡️ Connecting your Projects to Shared Services

To connect your projects to the shared services, configure your project's `docker-compose.yaml` file to connect to the shared network and Traefik.

For a quick example, you can check this [Laravel Starter Template](https://github.com/wayofdev/laravel-starter-tpl) repository's [docker-compose.yaml](https://github.com/wayofdev/laravel-starter-tpl/blob/develop/docker-compose.yaml) file, which includes a sample configuration for a Laravel project.

### → Sample Configuration

Your project should use the shared Docker network `network.ss` and Traefik labels to expose services to the outside world.

```diff
---

services:
  web:
    image: wayofdev/nginx:k8s-alpine-latest
    container_name: ${COMPOSE_PROJECT_NAME}-web
    restart: on-failure
+   networks:
+     - default
+     - shared
    depends_on:
      - app
    links:
      - app
    volumes:
      - ./app:/app:rw,cached
      - ./.env:/app/.env
+   labels:
+     - traefik.enable=true
+     - traefik.http.routers.api-${COMPOSE_PROJECT_NAME}-secure.rule=Host(`api.${COMPOSE_PROJECT_NAME}.docker`)
+     - traefik.http.routers.api-${COMPOSE_PROJECT_NAME}-secure.entrypoints=websecure
+     - traefik.http.routers.api-${COMPOSE_PROJECT_NAME}-secure.tls=true
+     - traefik.http.services.api-${COMPOSE_PROJECT_NAME}-secure.loadbalancer.server.port=8880
+     - traefik.docker.network=network.ss

networks:
+ shared:
+   external: true
+   name: network.ss
+ default:
+   name: project.laravel-starter-tpl

```

<br>

## 🔒 Security Policy

This project has a [security policy](.github/SECURITY.md).

<br>

## 🙌 Want to Contribute?

Thank you for considering contributing to the wayofdev community! We are open to all kinds of contributions. If you want to:

- 🤔 [Suggest a feature](https://github.com/wayofdev/docker-shared-services/issues/new?assignees=&labels=type%3A+enhancement&projects=&template=2-feature-request.yml&title=%5BFeature%5D%3A+)
- 🐛 [Report an issue](https://github.com/wayofdev/docker-shared-services/issues/new?assignees=&labels=type%3A+documentation%2Ctype%3A+maintenance&projects=&template=1-bug-report.yml&title=%5BBug%5D%3A+)
- 📖 [Improve documentation](https://github.com/wayofdev/docker-shared-services/issues/new?assignees=&labels=type%3A+documentation%2Ctype%3A+maintenance&projects=&template=4-docs-bug-report.yml&title=%5BDocs%5D%3A+)
- 👨‍💻 Contribute to the code

You are more than welcome. Before contributing, kindly check our [contribution guidelines](.github/CONTRIBUTING.md).

[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg?style=for-the-badge)](https://conventionalcommits.org)

<br>

## 🫡 Contributors

<p align="left">
  <a href="https://github.com/wayofdev/docker-shared-services/graphs/contributors">
      <img align="left" src="https://img.shields.io/github/contributors-anon/wayofdev/docker-shared-services?style=for-the-badge" alt="Contributors Badge"/>
  </a>
  <br>
</p>

<br>

## 🌐 Social Links

- **Twitter:** Follow our organization [@wayofdev](https://twitter.com/intent/follow?screen_name=wayofdev) and the author [@wlotyp](https://twitter.com/intent/follow?screen_name=wlotyp).
- **Discord:** Join our community on [Discord](https://discord.gg/CE3TcCC5vr).

<p align="left">
    <a href="https://discord.gg/CE3TcCC5vr" target="_blank"><img alt="Discord Link" src="https://img.shields.io/discord/1228506758562058391?style=for-the-badge&logo=discord&labelColor=7289d9&logoColor=white&color=39456d"></a>
    <a href="https://x.com/intent/follow?screen_name=wayofdev" target="_blank"><img alt="Follow on Twitter (X)" src="https://img.shields.io/badge/-Follow-black?style=for-the-badge&logo=X"></a>
</p>

<br>

## ⚖️ License

[![Licence](https://img.shields.io/github/license/wayofdev/docker-shared-services?style=for-the-badge&color=blue)](./LICENSE.md)

<br>
