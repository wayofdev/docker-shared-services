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

The repository provides Docker-powered local development experience for Dockerized projects, that is compatible with macOS and Linux.

Repository contains a set of docker-compose files and [Træfik](https://traefik.io/) configuration with SSL support, backed by mkcert, to allow running a local network with custom DNS, which enables support for developing microservices locally with access outside the Docker network.

### → Purpose

Developers will be familiar with the process of updating their `/etc/hosts` file to direct traffic for `yourproject.docker` or `yourproject.domain.docker` to `127.0.0.1`. Most will also be familiar with the problems of this approach:

- it requires a configuration change every time you add or remove a project; and
- it requires administration access to make the change.

For **Linux** and **macOS** users there is a solution – **dnsmasq**, which replaces the need for you, to edit the hosts file for each project you work with. Dnsmasq works good together with [Traefik](https://traefik.io/), mkcert and **Docker**.

This repository configures Traefik to run together with, installed in system, dnsmasq and serve you system-wide DNS solution to work with your microservices and use DNS and SSL features with local domains.

<br>

If you **like/use** this project, please consider ⭐️ **starring** it. Thanks!

<br>

## 🚩 Requirements

* **macOS** Monterey+ or **Linux**
* **Docker** 26.0 or newer
  * [How To Install and Use Docker on Ubuntu 22.04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)
* Installed [mkcert](https://github.com/FiloSottile/mkcert) binary in system
  * See full installation instructions in their official [README.md](https://github.com/FiloSottile/mkcert)
  * Quick installation on macOS: `brew install mkcert nss`
* ~~Installed and configured [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html) daemon~~
  * ~~Can be installed and configured automatically via our [ansible-role-dnsmasq](https://github.com/wayofdev/ansible-role-dnsmasq) ansible role~~
  * [DNSMasq](https://thekelleys.org.uk/dnsmasq/doc.html) service now is shipped and configured with this repository.

<br>

## ⚙️ Configuration

### → Cloning and setting up envs

1. Clone repository:

   ```bash
   $ git clone git@github.com:wayofdev/docker-shared-services.git
   ```

2. Generate default .env file:

   ```bash
   $ make env
   ```

   Edit the created `.env` file if necessary. You may want to change the default domain.

<br>

## 💻 Usage

### → Running with a blank shared domain segment:

Leave the `SHARED_DOMAIN_SEGMENT` blank to run shared services under the first level domain. For example:

   | Address         |
   |-----------------|
   | router.docker   |
   | pg-admin.docker |
   | ui.docker       |
   | etc.            |

<br>

### → Running with a default or custom shared domain segment:

Set the segment to run shared services under a subdomain: `SHARED_DOMAIN_SEGMENT=.wod`. Services will run under that segment. For example:

   | Address                 |
   |-------------------------|
   | router.__wod__.docker   |
   | pg-admin.__wod__.docker |
   | ui.__wod__.docker       |
   | etc.                    |

<br>

### → SSL certificates:

Don't forget to include first level domains into the `TLS_DOMAINS` variable. Default certificates will be created for these domains and wildcards:

| SSL certificate  | Comments                                                                                                    |
|------------------|-------------------------------------------------------------------------------------------------------------|
| ui.docker        | Included as fallback, if `SHARED_DOMAIN_SEGMENT` was left blank.                                            |
| router.docker    | Included as fallback, if `SHARED_DOMAIN_SEGMENT` was left blank.                                            |
| pg-admin.docker  | Included as fallback, if `SHARED_DOMAIN_SEGMENT` was left blank.                                            |
| *.wod.docker     | All subdomains under this wildcard. **Only one level of nesting **will work in most of the browsers****.    |
| *.tpl.wod.docker | For default template, generated from [laravel-starter-tpl](https://github.com/wayofdev/laravel-starter-tpl) |

<br>

### → Finishing:

1. Install root certificate into system and generate default certs:

   ```bash
   $ make cert-install
   ```

2. (Optional) Enable docker-compose.override file to run extra services, like pg-admin and others:

   ```bash
   $ make override
   ```

3. Run this repository:

   ```bash
   $ make up
   ```

4. Check that everything works:

   ```bash
   $ make ps
   $ make logs
   ```

<br>

### → Outcome

Services will be running under shared docker network, called `ss_shared_network` and all microservices, that will share same network, will be visible for Traefik, and local DNS, served by dnsmasq, will be available.

**Traefik dashboard** — [https://router.wod.docker](https://router.wod.docker/dashboard/#/)

![Alt text](assets/traefik.png?raw=true "Title")

**Portrainer** — https://ui.wod.docker or https://ui.docker

**Pg-admin** (if `docker-compose.override.yaml` was enabled) — https://pg-admin.wod.docker or https://pg-admin.docker

<br>

## 🧪 Testing

You can check `Makefile` to get full list of commands for local testing. For testing, you can use these commands to test whole role or separate tasks:

Testing docker-compose using `dcgoss`:

```bash
$ make test
```

<br>

## 🔒 Security Policy

This project has a [security policy](.github/SECURITY.md).

<br>

## 🙌 Want to Contribute?

Thank you for considering contributing to the wayofdev community! We are open to all kinds of contributions. If you want to:

* 🤔 [Suggest a feature](https://github.com/wayofdev/docker-shared-services/issues/new?assignees=&labels=type%3A+enhancement&projects=&template=2-feature-request.yml&title=%5BFeature%5D%3A+)
* 🐛 [Report an issue](https://github.com/wayofdev/docker-shared-services/issues/new?assignees=&labels=type%3A+documentation%2Ctype%3A+maintenance&projects=&template=1-bug-report.yml&title=%5BBug%5D%3A+)
* 📖 [Improve documentation](https://github.com/wayofdev/docker-shared-services/issues/new?assignees=&labels=type%3A+documentation%2Ctype%3A+maintenance&projects=&template=4-docs-bug-report.yml&title=%5BDocs%5D%3A+)
* 👨‍💻 Contribute to the code

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

* **Twitter:** Follow our organization [@wayofdev](https://twitter.com/intent/follow?screen_name=wayofdev) and the author [@wlotyp](https://twitter.com/intent/follow?screen_name=wlotyp).
* **Discord:** Join our community on [Discord](https://discord.gg/CE3TcCC5vr).

<p align="left">
    <a href="https://discord.gg/CE3TcCC5vr" target="_blank"><img alt="Discord Link" src="https://img.shields.io/discord/1228506758562058391?style=for-the-badge&logo=discord&labelColor=7289d9&logoColor=white&color=39456d"></a>
    <a href="https://x.com/intent/follow?screen_name=wayofdev" target="_blank"><img alt="Follow on Twitter (X)" src="https://img.shields.io/badge/-Follow-black?style=for-the-badge&logo=X"></a>
</p>

<br>

## ⚖️ License

[![Licence](https://img.shields.io/github/license/wayofdev/docker-shared-services?style=for-the-badge&color=blue)](./LICENSE.md)

<br>
