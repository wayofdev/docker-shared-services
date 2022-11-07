<br>

<div align="center">
<img width="456" src="https://raw.githubusercontent.com/wayofdev/docker-shared-services/master/assets/logo.gh-light-mode-only.png#gh-light-mode-only">
<img width="456" src="https://raw.githubusercontent.com/wayofdev/docker-shared-services/master/assets/logo.gh-dark-mode-only.png#gh-dark-mode-only">
</div>



<br>

<br>

<div align="center">
<a href="https://actions-badge.atrox.dev/wayofdev/docker-shared-services/goto"><img alt="Build Status" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fwayofdev%2Fdocker-shared-services%2Fbadge&style=flat-square"/></a>
<a href="https://github.com/wayofdev/docker-shared-services/tags"><img src="https://img.shields.io/github/v/tag/wayofdev/docker-shared-services?sort=semver&style=flat-square" alt="Latest Version"></a>
<a href="LICENSE"><img src="https://img.shields.io/github/license/wayofdev/docker-shared-services.svg?style=flat-square&color=blue" alt="Software License"/></a>
<a href="#"><img alt="Commits since latest release" src="https://img.shields.io/github/commits-since/wayofdev/docker-shared-services/latest?style=flat-square"></a>
</div>


<br>

# Docker Shared Services

The repository provides Docker-powered local development experience for WOD projects that is compatible with macOS and Linux.

Repository contains a set of docker-compose files and [Træfik](https://traefik.io/) configuration with SSL support to allow running a local network with custom DNS, which enables support for developing microservices locally with access outside the Docker network.

### → Purpose

Developers will be familiar with the process of updating your `/etc/hosts` file to direct traffic for `yourproject.docker` or `yourproject.domain.docker` to `127.0.0.1`. Most will also be familiar with the problems of this approach:

- it requires a configuration change every time you add or remove a project; and
- it requires administration access to make the change.

For **Linux** and **macOS** users there is a solution – **dnsmasq**, which replaces the need for you, to edit the hosts file for each project you work with. Dnsmasq works good together with [Træfik](https://traefik.io/) and **Docker**.

This repository configures Traefik to run together with, installed in system, dnsmasq and serve you system wide DNS solution to work with your microservices and use DNS and SSL features with local domains.

<br>

## 📑 Requirements

* **macOS** Monterey or **Linux**
* **Docker** 20.10 or newer
  * [How To Install and Use Docker on Ubuntu 22.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)
* Installed [mkcert](https://github.com/FiloSottile/mkcert) binary in system
  * See full installation instructions in their official [README.md](https://github.com/FiloSottile/mkcert)
  * Quick installation on macOS: `brew install mkcert nss`
* Installed and configured [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) daemon
  * Can be installed and configured automatically via our own [ansible-role-dnsmasq](https://github.com/wayofdev/ansible-role-dnsmasq)

<br>

## ⚙️ How to Use

### → Instructions

1. Download repository:

   ```bash
   $ git clone git@github.com:wayofdev/docker-shared-services.git
   ```

2. Generate default .env file:

   ```bash
   $ make env
   ```

   Edit created .env file, if it is needed. Probably you will want to change default domain.

   Leave blank `SHARED_DOMAIN_SEGMENT`, to run shared services under first level domain, example:

   * router.docker, 
   * pg-admin.docker, 
   * ui.docker
   * etc.

   Or set segment, to run them under subdomain: `SHARED_DOMAIN_SEGMENT=".wod"` Services will run under that segment, example:

   * router**.wod**.docker
   * pg-admin**.wod**.docker
   * ui**.wod**.docker
   * etc

   Don't forget to include first level domains into `TLS_DOMAINS` variable. Default certificates will be created for these domains and wildcards:

   * ui.docker — Included as fallback, if `SHARED_DOMAIN_SEGMENT` was left blank
   * router.docker — Included as fallback, if `SHARED_DOMAIN_SEGMENT` was left blank
   * pg-admin.docker — Included as fallback, if `SHARED_DOMAIN_SEGMENT` was left blank
   * *.wod.docker — All subdomains under this wildcard. Only one level of nesting will work in most of the browsers
   * *.wod.mac — Same as above wildcard

3. Install root certificate into system and generate default certs:
   ```bash
   $ make cert-install
   ```

4. (Optional) Enable docker-compose.override file to run extra services, like pg-admin and others:
   ```bash
   $ make override
   ```

5. Run this repository:

   ```bash
   $ make up
   ```

<br>

### → Outcome

Services will be running under shared docker network, called `ss_shared_network` and all microservices, that will share same network, will be visible for Traefik, and local DNS, served by dnsmasq, will be available.

**Traefik dashboard** — [https://router.wod.docker](https://router.wod.docker/dashboard/#/)

![Alt text](assets/traefik.png?raw=true "Title")

**Portrainer** — https://ui.wod.docker

**Pg-admin** (if docker-compose.override was enabled) — https://pg-admin.wod.docker

<br>

## 🧪 Testing

You can check `Makefile` to get full list of commands for local testing. For testing, you can use these commands to test whole role or separate tasks:

Testing docker-compose using dcgoss:

```bash
$ make test
```

<br>

## 🤝 License

[![Licence](https://img.shields.io/github/license/wayofdev/docker-shared-services?style=for-the-badge&color=blue)](./LICENSE)

<br>

## 🙆🏼‍♂️ Author Information

This repository was created in **2022** by [lotyp / wayofdev](https://github.com/wayofdev).

<br>

## 🫡 Contributors

<img align="left" src="https://img.shields.io/github/contributors-anon/wayofdev/docker-shared-services?style=for-the-badge"/>

<a href="https://github.com/wayofdev/docker-nginx/graphs/contributors">
  <img src="https://opencollective.com/wod/contributors.svg?width=890&button=false">
</a>

<br>
