# Part 3 — Black Hat Bash Lab: Setup & Hacking Techniques

> **Integrative Project — UIDE · March–July 2026**
> Instructor: Ing. Jonathan E. Tito O., MSc.
> Reference: Chapter 3, Black Hat Bash · https://github.com/dolevf/Black-Hat-Bash

---

## 3.A — Lab Setup

### Prerequisites

- Docker 29.1.3
- Docker Compose v2.27.0
- Linux Mint 22 (inside VirtualBox)

### Installation Steps

**1. Install Docker Compose:**

    sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo mkdir -p /root/.docker/cli-plugins
    sudo ln -s /usr/local/bin/docker-compose /root/.docker/cli-plugins/docker-compose

**2. Clone the repository:**

    git clone https://github.com/dolevf/Black-Hat-Bash.git
    cd Black-Hat-Bash/lab

**3. Deploy the lab:**

    sudo make deploy

**4. Monitor deployment:**

    tail -f /var/log/lab-install.log

### Verification

    sudo make test
    # Output: Lab is up.

    sudo docker ps --format "{{.Names}}"
    # p-web-02, p-jumpbox-01, p-web-01, p-ftp-01, c-backup-01, c-redis-01, c-db-02, c-db-01

    ip addr | grep "br_"
    # br_corporate: 10.1.0.1/24
    # br_public:    172.16.10.1/24

---

## Lab Architecture

### Network Diagram

    Internet (isolated)
            |
       [br_public] 172.16.10.0/24
            |
       p-web-01    172.16.10.10   Python/Werkzeug app (port 8081)
       p-ftp-01    172.16.10.11   FTP + Apache web server
       p-web-02    172.16.10.12   Apache/PHP website
       p-jumpbox   172.16.10.13   SSH jump box
            |
       [br_corporate] 10.1.0.0/24
            |
       c-db-01     10.1.0.x       Database server
       c-db-02     10.1.0.x       Database server
       c-redis-01  10.1.0.x       Redis cache
       c-backup-01 10.1.0.x       Backup server

### Machine Table

| Container | Public IP | Corporate IP | Services |
|---|---|---|---|
| p-web-01 | 172.16.10.10 | — | HTTP/8081 Werkzeug/Python |
| p-ftp-01 | 172.16.10.11 | — | FTP/21 vsftpd, HTTP/80 Apache |
| p-web-02 | 172.16.10.12 | — | HTTP/80 Apache/PHP |
| p-jumpbox-01 | 172.16.10.13 | — | SSH/22 OpenSSH |
| c-db-01 | — | 10.1.0.x | Database |
| c-db-02 | — | 10.1.0.x | Database |
| c-redis-01 | — | 10.1.0.x | Redis |
| c-backup-01 | — | 10.1.0.x | Backup |

---

## 3.B — Hacking Techniques

> All techniques were executed exclusively against the isolated lab environment.

---

### Technique 1 — Network Port Scan with Nmap

**What it does:** Nmap sends TCP packets to each port and records which ones respond, revealing services and versions running on the network. This is the first step in any reconnaissance.

**Command:**

    sudo nmap -sV 172.16.10.0/24

**Results:**

    172.16.10.10 -> 8081/tcp open  Werkzeug/3.0.1 Python/3.12.3
    172.16.10.11 -> 21/tcp   open  vsftpd 3.0.5
                   80/tcp   open  Apache httpd 2.4.58 (Ubuntu)
    172.16.10.12 -> 80/tcp   open  Apache httpd 2.4.57 (Debian)
    172.16.10.13 -> 22/tcp   open  OpenSSH 9.6p1 Ubuntu

**Interpretation:**
- p-web-01 runs Werkzeug, a Python development server not intended for production — a common misconfiguration that reveals the exact framework version.
- p-ftp-01 exposes both FTP and HTTP. Having FTP open alongside a web server is risky — if anonymous access is enabled, an attacker can read or modify files.
- p-web-02 runs a standard LAMP stack (Apache + PHP).
- p-jumpbox-01 only exposes SSH, serving as the gateway to the corporate network.

---

### Technique 2 — Web Stack Fingerprinting with WhatWeb

**What it does:** WhatWeb identifies the technologies behind a web server — framework, language, CMS, JavaScript libraries, server version. This helps an attacker choose the right exploit or identify outdated software.

**Commands:**

    whatweb 172.16.10.10:8081
    whatweb 172.16.10.11:80
    whatweb 172.16.10.12:80

**Results:**

    172.16.10.10:8081 -> Werkzeug/3.0.1, Python/3.12.3, Title: Menu
    172.16.10.11:80   -> Apache/2.4.58 (Ubuntu), Title: Apache2 Ubuntu Default Page
    172.16.10.12:80   -> Apache/2.4.57 (Debian), PHP/8.2.17, Bootstrap/4.3.1
                         Title: ACME Impact Alliance Charity Website
                         X-Powered-By: PHP/8.2.17

**Interpretation:**
- p-web-01 leaks its backend technology in HTTP headers, enabling direct CVE lookups.
- p-ftp-01 shows the Apache default page, indicating a misconfigured or incomplete deployment.
- p-web-02 exposes PHP version via X-Powered-By header. This header should always be disabled in production as it directly reveals which PHP vulnerabilities apply.

---

### Technique 3 — Anonymous FTP Login

**What it does:** FTP servers can allow anonymous login with no password. This is a critical misconfiguration that enables unauthenticated file access.

**Commands:**

    ftp 172.16.10.11
    Username: anonymous
    Password: (blank — just press Enter)

    ftp> ls
    ftp> ls backup
    ftp> get index.html

**Results:**

    230 Login successful.

    /
    drwxr-xr-x  backup/
    -rw-r--r--  index.html (10671 bytes)

    /backup/
    drwxr-xr-x  acme-hyper-branding/
    drwxr-xr-x  acme-impact-alliance/

    index.html downloaded successfully (10671 bytes)

**Interpretation:**
- The FTP server accepts anonymous login with no credentials — a critical misconfiguration.
- The root directory exposes an index.html and a backup folder containing two internal company projects (acme-hyper-branding, acme-impact-alliance).
- We successfully downloaded index.html without any authentication. In a real scenario this could expose source code, configuration files, database dumps, or credentials.
- The backup directory names reveal internal project structure, valuable for social engineering or targeted attacks.

---

## Criteria Checklist

| Criterion | Status |
|---|---|
| Docker + Compose ready, make deploy successful | ✅ |
| make test = Lab is up + 8 containers running | ✅ |
| Networks validated br_public / br_corporate | ✅ |
| Architecture table + docker exec demonstrated | ✅ |
| 3 techniques executed with evidence | ✅ |
| Technical interpretation of each result | ✅ |
| Basic + Intermediate level techniques | ✅ |

---

## Team

| Member | Role |
|---|---|
| Cristopher Quisilema | Lab deployment, reconnaissance, FTP exploitation |

---
capture
<img width="440" height="72" alt="image" src="https://github.com/user-attachments/assets/93ec6d1f-1c6f-4bd2-8689-5017e9281bbb" />
<img width="448" height="44" alt="image" src="https://github.com/user-attachments/assets/40f7d14d-7f62-47fb-a43f-ceb0bb2c451d" />
<img width="448" height="101" alt="image" src="https://github.com/user-attachments/assets/8293f73f-f194-44c7-9576-73fcd4951245" />
<img width="445" height="232" alt="image" src="https://github.com/user-attachments/assets/c927191d-b871-4992-8e00-cc53e464f3ff" />
<img width="437" height="32" alt="image" src="https://github.com/user-attachments/assets/4a2a430d-fbd4-4dd2-b98a-3c059562220e" />
<img width="461" height="272" alt="image" src="https://github.com/user-attachments/assets/de1927b1-359b-4954-83ad-c76e30d6acfe" />
<img width="445" height="88" alt="image" src="https://github.com/user-attachments/assets/634aabec-1e44-4689-8bd0-33e3a7db6a0b" />
<img width="437" height="175" alt="image" src="https://github.com/user-attachments/assets/406de9e3-94fe-4590-a542-c8b81869e9a0" />






## References

- [Black Hat Bash GitHub](https://github.com/dolevf/Black-Hat-Bash)
- [Nmap Reference Guide](https://nmap.org/book/man.html)
- [WhatWeb GitHub](https://github.com/urbanadventurer/WhatWeb)
- [vsftpd Documentation](https://security.appspot.com/vsftpd.html)
