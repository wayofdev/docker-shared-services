<p align="center">
    <br>
    <a href="https://wayof.dev" target="_blank">
        <picture>
            <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/wayofdev/.github/master/assets/logo.gh-dark-mode-only.png">
            <img width="400" src="https://raw.githubusercontent.com/wayofdev/.github/master/assets/logo.gh-light-mode-only.png" alt="WayOfDev Logo">
        </picture>
    </a>
    <br>
</p>

<p align="center">
<a href="https://actions-badge.atrox.dev/wayofdev/docker-shared-services/goto"><img alt="Build Status" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fwayofdev%2Fdocker-shared-services%2Fbadge&style=flat-square&label=github%20actions"/></a>
<a href="https://github.com/wayofdev/docker-shared-services/tags"><img src="https://img.shields.io/github/v/tag/wayofdev/docker-shared-services?sort=semver&style=flat-square&label=version" alt="Latest Stable Version"></a>
<a href="LICENSE.md"><img src="https://img.shields.io/github/license/wayofdev/docker-shared-services.svg?style=flat-square&color=blue" alt="Software License"/></a>
<a href="https://github.com/wayofdev/docker-shared-services/commits/master"><img src="https://img.shields.io/github/commits-since/wayofdev/docker-shared-services/latest?style=flat-square" alt="Commits since latest release"></a>
<a href="https://discord.gg/CE3TcCC5vr" target="_blank"><img alt="Discord Link" src="https://img.shields.io/discord/1228506758562058391?style=flat-square&logo=discord&labelColor=7289d9&logoColor=white&color=39456d"></a>
<a href="https://x.com/intent/follow?screen_name=wayofdev" target="_blank"><img alt="Follow on Twitter (X)" src="https://img.shields.io/badge/-Follow-black?style=flat-square&logo=X"></a>
<br>
</p>

# Docker Shared Services

This repository provides a Docker-powered local development environment for Dockerized projects, compatible with macOS and Linux.

It includes a set of docker-compose files and [Træfik](https://traefik.io/) configuration with SSL support, backed by [mkcert](https://github.com/FiloSottile/mkcert), to enable running a local network with custom DNS provided by [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html). This setup facilitates developing microservices locally with access outside the Docker network.

<br>

## 🗂️ Table of Contents

- [Key Features](#-key-features)
- [Purpose](#-purpose)
- [Requirements](#-requirements)
- [Quick Start Guide (macOS)](#-quick-start-guide-macos)
- [Quick Start Guide (Linux)](#-quick-start-guide-linux)
- [Connecting your Projects to Shared Services](#-connecting-your-projects-to-shared-services)
- [Example: Spin-up Laravel Sail Project](#-example-spin-up-laravel-sail-project)
- [Example: Want to See a Ready-Made Template?](#-example-want-to-see-a-ready-made-template)
- [Security Policy](#-security-policy)
- [Want to Contribute?](#-want-to-contribute)
- [Contributors](#-contributors)
- [Social Links](#-social-links)
- [License](#-license)

<br>

## 🌟 Key Features

- **Automated Local DNS and SSL Setup**: Eliminates manual edits to `/etc/hosts` and self-signed certificate warnings.
- **Consistent Development Environment**: Uniform setup for all team members, reducing environment-related bugs.
- **Elimination of Port Conflicts**: Traefik handles port management, allowing multiple dockerized projects to run concurrently.
- **User-Friendly Local URLs**: Access projects via custom local domains like `project.docker` instead of `localhost:8000`.
- **Simplified CORS and Cookie Management**: SSL support for local domains mirrors production settings.
- **Enhanced Testing Environment**: Test OAuth, secure cookies, and HTTPS APIs locally.
- **Improved Service Discovery and Routing**: Traefik automates service discovery and routing within your Docker network.
- **Ease of Integration with Existing Projects**: Connect your existing Docker projects to this setup effortlessly.

<br>

## 🤔 Purpose

### → Simplifying Local Development

This project simplifies local development by addressing common issues such as:

- Frequent updates to the `/etc/hosts` file.
- Requirement of administrative access for changes.
- Lack of SSL support for custom domains.
- Port conflicts when forwarding Docker service ports to the host machine.
- Use of cumbersome hostnames like `localhost:8800` for local projects.
- Complex CORS setup and Cookie configuration.

For Linux and macOS users, dnsmasq eliminates the need to edit the hosts file for each project, providing a streamlined solution when used with Traefik, mkcert, and Docker. This repository configures Traefik to work with dnsmasq, offering a system-wide DNS solution for microservices and enabling DNS and SSL features with local domains.

<br>

## 👏 Benefits for Team

### → Enhance Development Workflow

Integrating this Docker Shared Services project into your team's tech stack can significantly enhance your development workflow. This setup is compatible with a wide range of HTTP-based projects, including backend frameworks like Laravel, Symfony, or Spiral, frontend frameworks, and any other services that run in Docker and communicate over HTTP.

By standardizing the local network setup across different machines, your team can:

- Maintain consistency.
- Reduce configuration work.
- Resolve port conflicts between multiple Docker services.
- Provide SSL support for local domains.
- Work with CORS and Cookies in a scenario close to production.
- Set up OAuth providers to work with custom local domains.

This ensures smoother collaboration and boosts overall productivity.

<br>

If you **like/use** this project, please consider ⭐️ **starring** it. Thanks!

<br>

## 🚩 Requirements

- **macOS** Monterey+ or **Linux**
- **Docker** 26.0 or newer
  - [How To Install and Use Docker on Ubuntu 22.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)
  - [How To Install Docker Desktop on Mac](https://docs.docker.com/desktop/install/mac-install/)
- Installed [mkcert](https://github.com/FiloSottile/mkcert) binary in system
  - See full installation instructions in their official [README.md](https://github.com/FiloSottile/mkcert)
  - Quick installation on macOS: `brew install mkcert nss`
- ~~Installed and configured [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) daemon~~
  - ~~Can be installed and configured automatically via our [ansible-role-dnsmasq](https://github.com/wayofdev/ansible-role-dnsmasq) ansible role~~
  - [DNSMasq](https://thekelleys.org.uk/dnsmasq/doc.html) service now is shipped and configured with this repository.

<br>

## 💻 Quick Start Guide (macOS)

1. **Install Homebrew** (if not installed):

   If [Homebrew](https://brew.sh) is not already installed, run the following command:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install Docker** (if not installed):

   Set up Docker Desktop via Homebrew:

      ```bash
      brew install --cask docker
      ```

3. **Install `mkcert` and `nss`:**

   `mkcert` is a tool that creates locally-trusted development certificates, and `nss` provides support for mkcert certificates in Firefox.

   ```bash
   brew install mkcert nss
   ```

4. **Create shared project directory:**

   This repository should be run once per machine, so let's create a shared directory for this project:

   ```bash
   mkdir -p ~/projects/infra && cd ~/projects/infra
   ```

5. **Clone this repository:**

      ```bash
      git clone \
        git@github.com:wayofdev/docker-shared-services.git \
        ~/projects/infra/docker-shared-services && \
      cd ~/projects/infra/docker-shared-services
      ```

6. **Create `.env` file:**

   Generate a default `.env` file, which contains configuration settings for the project.

   ```bash
   make env
   ```

   Open this file and read the notes inside to make any necessary changes to fit your setup.

7. **Install root certificate** and generate default project certs:

   This step installs the root certificate into your system's trust store and generates default SSL certificates for your local domains, which are listed in the `.env` file, under the variable `TLS_DOMAINS`.

   ```bash
   make cert-install
   ```

      > [!Note]
      >
      > Currently, on macOS, you may need to enter your password several times to allow `mkcert` to install the root certificate.
      > **This is a one-time operation** and details can be found in this upstream GitHub [issue](https://github.com/FiloSottile/mkcert/issues/415).

8. **Run this project:**

   Start the Docker services defined in the repository.

   ```bash
   make up
   ```

9. **Check that all Docker services are running:**

   Ensure Docker is running and services are up by using the `make ps` and `make logs` commands.

   ```bash
   make ps
   make logs
   ```

10. **Add custom DNS resolver to your system:**

    This allows macOS to understand that `*.docker` domains should be resolved by a custom resolver via `127.0.0.1`, where our DNSMasq, which runs inside Docker, will handle all DNS requests.

    ```bash
    sudo sh -c 'echo "nameserver 127.0.0.1" > /etc/resolver/docker'
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    ```

    You can check that DNS was added by running:

    ```bash
    scutil --dns
    ```

    Example output:

    ```bash
    resolver #8
    domain   : docker
    nameserver[0] : 127.0.0.1
    flags    : Request A records, Request AAAA records
    reach    : 0x00030002 (Reachable,Local Address,Directly Reachable Address)
    ```

    > [!Note]
    >
    > Instead of creating the `/etc/resolver/docker` file, you can add `127.0.0.1` to your macOS DNS Servers in your Ethernet or Wi-Fi settings.
    >
    > Go to **System Preferences → Network → Wi-Fi → Details → DNS** and add `127.0.0.1` as the first DNS server.
    >
    > This allows you to do it one time, and if you need to create a new local domain, for example `*.mac`, in the future, it will be automatically resolved without creating a separate `/etc/resolver/mac` file.

11. **Ping `router.docker` to check if DNS is working:**

    Ensure that the DNS setup is functioning correctly.

    ```bash
    ping router.docker -c 3
    ping any-domain.docker -c 3
    ```

12. **Access Traefik dashboard:**

    Open [https://router.docker](https://router.docker).

    You should see the Traefik Dashboard:

    ![Traefik dashboard](.github/assets/traefik.png?raw=true "Traefik dashboard example")

### → Outcome

At this point, you should have a working local development environment with DNS and SSL support ready to be used with your projects.

Services will be running under a shared Docker network called `network.ss`, and all projects or microservices that will share the same [Docker network](https://docs.docker.com/network/) will be visible to Traefik. The local DNS, served by DNSMasq, will be available on `*.docker` domains.

<br>

## 🐧 Quick Start Guide (Linux)

In this section, we'll walk through setting up the `docker-shared-services` project on an Ubuntu distribution. While the steps are specific to Ubuntu, they should be adaptable to other Linux distributions with minor modifications.

1. **Install Docker:**
   Easiest and quickest way to get started is to [install Docker Desktop for Linux](https://docs.docker.com/desktop/install/linux-install/#generic-installation-steps).

   - [Install Docker Desktop on Ubuntu](https://docs.docker.com/desktop/install/ubuntu/)

2. **Install `certutil`:**

   ```bash
   sudo apt update
   sudo apt install libnss3-tools
   ```

3. **Install `mkcert`:**

   ```bash
   curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
   chmod +x mkcert-v*-linux-amd64
   sudo cp mkcert-v*-linux-amd64 /usr/local/bin/mkcert
   ```

   More detailed instructions can be found in the [`mkcert README.md`](https://github.com/FiloSottile/mkcert?tab=readme-ov-file#linux).

4. **Create shared project directory:**

   ```bash
   mkdir -p ~/projects/infra && cd ~/projects/infra
   ```

5. **Clone this repository:**

   ```bash
   git clone \
     git@github.com:wayofdev/docker-shared-services.git \
     ~/projects/infra/docker-shared-services && \
   cd ~/projects/infra/docker-shared-services
   ```

6. **Create `.env` file:**

   Generate a default `.env` file, which contains configuration settings for the project.

   ```bash
   make env
   ```

   Open this file and read the notes inside to make any necessary changes to fit your setup.

7. **Install root certificate** and generate default project certs:

   ```bash
   make cert-install
   ```

8. **Disable stub DNS listener:**

   To prevent conflicts with the DNSMasq service, disable the stub DNS listener in the `systemd-resolved` service.

   ```bash
   sudo sed -i 's/#DNSStubListener=yes/DNSStubListener=no/' /etc/systemd/resolved.conf
   sudo systemctl restart systemd-resolved
   ```

9. **Edit /etc/resolv.conf:**

   Update the `/etc/resolv.conf` file to use the local DNS server.

   ```bash
   echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf > /dev/null
   ```

   Editing `/etc/resolv.conf` directly is not recommended for persistent changes since it is often managed by other services (like Netplan or NetworkManager). However, for a temporary change, you can use:

10. **Run this project:**

    Start the Docker services defined in the repository.

    ```bash
    make up
    ```

11. **Check that all Docker services are running:**

    Ensure Docker is running and services are up by using the `make ps` and `make logs` commands.

    ```bash
    make ps
    make logs
    ```

12. **Ping `router.docker` to check if DNS is working:**

    Ensure that the DNS setup is functioning correctly.

    ```bash
    ping router.docker -c 3
    ping any-domain.docker -c 3
    ```

13. **Access Traefik dashboard:**

    Open [https://router.docker](https://router.docker).

    You should see the Traefik Dashboard:

    ![Traefik dashboard](.github/assets/traefik.png?raw=true "Traefik dashboard example")

### → Outcome

At this point, you should have a working local development environment with DNS and SSL support ready to be used with your projects.

Services will be running under a shared Docker network called `network.ss`, and all projects or microservices that will share the same [Docker network](https://docs.docker.com/network/) will be visible to Traefik. The local DNS, served by DNSMasq, will be available on `*.docker` domains.

<br>

## 🔌 Connecting your Projects to Shared Services

To connect your projects to the shared services, configure your project's `docker-compose.yaml` file to connect to the shared network and Traefik.

This project comes with an example Portainer service, which also starts by default with the `make up` command. You can check the [`docker-compose.yaml`](https://github.com/wayofdev/docker-shared-services/blob/master/docker-compose.yaml) to see how Traefik labels and the shared network are used to spin up Portainer on the <https://ui.docker> host, which supports SSL by default.

### → Sample Configuration

Your project should use the shared Docker network `network.ss` and Traefik labels to expose services to the outside world.

1. **Change your project's `docker-compose.yaml` file:**

      ```diff
      ---

      services:
        web:
          image: wayofdev/nginx:k8s-alpine-latest
          restart: on-failure
      +   networks:
      +     - default
      +     - shared
          volumes:
            - ./app:/app:rw,cached
      +   labels:
      +     - traefik.enable=true
      +     - traefik.http.routers.api-my-project-secure.rule=Host(`api.my-project.docker`)
      +     - traefik.http.routers.api-my-project-secure.entrypoints=websecure
      +     - traefik.http.routers.api-my-project-secure.tls=true
      +     - traefik.http.services.api-my-project-secure.loadbalancer.server.port=8880
      +     - traefik.docker.network=network.ss

      networks:
      + shared:
      +   external: true
      +   name: network.ss
      + default:
      +   name: project.my-project
      ```

   In this configuration, we added the shared network and Traefik labels to the web service. These labels help Traefik route the traffic to the service based on the specified rules.

   Replace `my-project` with your preferred project name.

2. **Generate SSL certs for your project:**

   Go to the `docker-shared-services` directory:

   ```bash
   cd ~/projects/infra/docker-shared-services
   ```

   Edit the `.env` file to add your custom domain:

   ```bash
   nano .env
   ```

   Add `*.my-project.docker` to end of `TLS_DOMAINS` variable:

   ```bash
   TLS_DOMAINS="ui.docker router.docker *.my-project.docker"
   ```

   Generate SSL certificates and reload `docker-shared-services`:

   ```bash
   make cert-install restart
   ```

<br>

## 🚀 Example: Spin-up Laravel Sail Project

Let's walk through an example of setting up a Laravel project using Sail and integrating it with the `docker-shared-services`.

1. Create an example Laravel project based on Sail:

   ```bash
   curl -s "https://laravel.build/example-app" | bash
   ```

2. Open the `docker-compose.yaml` file of the `example-app` project and make adjustments:

   ```diff
   services:
     laravel.test:
       build:
         context: ./vendor/laravel/sail/runtimes/8.3
         dockerfile: Dockerfile
         args:
           WWWGROUP: '${WWWGROUP}'
       image: sail-8.3/app
   -   extra_hosts:
   -     - 'host.docker.internal:host-gateway'
       ports:
   -     - '${APP_PORT:-80}:80'
   -     - '${VITE_PORT:-5173}:${VITE_PORT:-5173}'
       networks:
         - sail
   +     - shared
       depends_on:
         - ...
   +   labels:
   +     - traefik.enable=true
   +     - traefik.http.routers.test-laravel-app-secure.rule=Host(`api.laravel-app.docker`)
   +     - traefik.http.routers.test-laravel-app-secure.entrypoints=websecure
   +     - traefik.http.routers.test-laravel-app-secure.tls=true
   +     - traefik.http.services.test-laravel-app-secure.loadbalancer.server.port=80
   +     - traefik.docker.network=network.ss

     mailpit:
       image: 'axllent/mailpit:latest'
       networks:
         - sail
   +     - shared
       ports:
   -     - '${FORWARD_MAILPIT_PORT:-1025}:1025'
   -     - '${FORWARD_MAILPIT_DASHBOARD_PORT:-8025}:8025'
   +   labels:
   +     - traefik.enable=true
   +     - traefik.http.routers.mail-laravel-app-secure.rule=Host(`mail.laravel-app.docker`)
   +     - traefik.http.routers.mail-laravel-app-secure.entrypoints=websecure
   +     - traefik.http.routers.mail-laravel-app-secure.tls=true
   +     - traefik.http.services.mail-laravel-app-secure.loadbalancer.server.port=8025
   +     - traefik.docker.network=network.ss

   networks:
     sail:
       driver: bridge
   + shared:
   +   external: true
   +   name: network.ss
   ```

   These changes connect the Laravel app and Mailpit docker services to the shared network and expose them via Traefik.

3. **Run the Laravel project:**

   Navigate to the `example-app` directory and start the services using Sail.

   ```bash
   ./vendor/bin/sail up -d
   ```

4. **Check Traefik routers**:

   Open <https://router.docker/dashboard/#/http/routers> and check that there are two routers:

   - `Host(api.laravel-app.docker)`  → `test-laravel-app-secure@docker`
   - `Host(mail.laravel-app.docker)` → `mail-laravel-app-secure@docker`

   ![Traefik Routers](.github/assets/traefik-routers.png?raw=true "Traefik Routers Example")

5. **Check the setup**:

   Ensure that your Laravel application and Mailpit services are running correctly by accessing their respective domains:

   - **Laravel app** — [https://api.laravel-app.docker](https://api.laravel-app.docker/)
   - **Mailpit** — [https://mail.laravel-app.docker](https://mail.laravel-app.docker/)

At this point, your Laravel project is integrated with the `wayofdev/docker-shared-services`, utilizing DNS and SSL support for local development.

<br>

## 👀 Example: Want to See a Ready-Made Template?

If you come from the PHP or Laravel world, or if you want to see how a complete project can be integrated with `docker-shared-services`, check out [wayofdev/laravel-starter-tpl](https://github.com/wayofdev/laravel-starter-tpl).

This Dockerized Laravel starter template works seamlessly with [wayofdev/docker-shared-services](https://github.com/wayofdev/docker-shared-services), providing a foundation with integrated DNS and SSL support, and can show you `the way` to implement patterns, stated in this article, in your projects.

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
<br>
</p>

## 🌐 Social Links

- **Twitter:** Follow our organization [@wayofdev](https://twitter.com/intent/follow?screen_name=wayofdev) and the author [@wlotyp](https://twitter.com/intent/follow?screen_name=wlotyp).
- **Discord:** Join our community on [Discord](https://discord.gg/CE3TcCC5vr).

<br>

## 📄 License

[![Licence](https://img.shields.io/github/license/wayofdev/docker-shared-services?style=for-the-badge&color=blue)](./LICENSE.md)

<br>
