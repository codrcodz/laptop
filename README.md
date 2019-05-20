# laptop

## Usage

`ansible-playbook -K laptop.yml [--tags place_optional_tag_name_here]`



## Supported Operating Systems

This role has been tested on the following operating systems:

  - Pop_OS! 18.04

While the role may also work on related distributions with a similar lineage (i.e. Ubuntu 18.04 LTS), it has not been tested on them. Also note: while some of the individual tasks files have not been tested on other distributions, many of them do not have distribution specific configurations that would preclude them from working with other distributions. Review the individual tasks files prior to running to determine if that is the case. Also, please note: PRs are welcome for adding support for other distributions, but there are no plans at this time to go out of the way to support anything other than Ubuntu-based LTS releases.


## Default Tags

All of these tags run implicitly if no tags are passed to `ansible-playbook`. Each tag has a one-to-one mapping to a `<tag_name>.yml` file within the repository within `/roles/laptop/tasks/`. If the `--tags` flag is not used with `ansible-playbook`, all the task files below will execute their tasks, (see `main.yml` for the order); however, if `--tag <tag>` is passed, only the tasks associated with that task file and tag will be executed.

  - bashrc - makes some additions to bashrc file, most to the path
  - docker-compose - installs docker-compse, and keeps it at latest non-alpha version
  - docker - installs docker
  - doctl - installs the DigitalOcean API command-line interface, and keepts it at latest release
  - firewall - uninstalls ufw, installs firewalld, and manages firewall rules on multiple zones
  - git - configures git settings
  - hub - installs Github's hub utility and keeps it at latest non-alpha version
  - python-packages - installs user-specific and global python packages
  - repos - installs addtional repositories
  - system-packages - installs system packages and keeps them at latest
  - terraform - installs terraform, and keeps it at latest non-alpha version
  - travis - installs travis-ci gem and keeps it at latest version
  - vagrant - installs vagrant, and keeps it at latest non-alpha version


## Never Tags

These tags _only_ run when the specified tag is passed to `ansible-playbook` via `--tags`

  - docker-images - installs docker-images
  - storage - mounts additional partitions and manages LVM partitions (does not run by default)
  - vagrant-boxes - installs select vagrant boxes, and keeps them at latest version (does not run by default)


## Variables

Default variables are located in `roles/laptop/defaults/main.yml`.

Feel free to change lists by replacing them in `host_vars/localhost` with a list of the same name. At a minimum, it is recommended that you change the following:

```
username: "ccochran"
github_name: "codrcodz"
email: "cody.l.cochran@gmail.com"
homedir: "/home/ccochran"
```

## Features

Each tasks file (which maps one-to-one to a tag) is setup to be modular and have a specific purpose. This section of the `README.md` documents each one to give the user a better idea of whateach does.

### bashrc

This file adds one or more `~/.bashrc.d/<file>` files in order to bootstrap things like the `PATH` variable, ensuring certain commands are available. This tasks file should be OS-neutral.

### docker-compose

This file adds the `docker-compose` utility/command to the path fro Github Releases, and pulls from "latest" tag. This tasks file should be OS-neutral.

### docker

This file adds `docker` to the system through `apt`, and is not currently OS-neutral.

### doctl

This file adds `doctl` to the path by downloading from Github Releases, and pulls from the "latest" tag; should be OS-neutral.

### firewall

This file does quite a bit. First, it disables UFW and installs Firewalld; next, it parses zones and firewall rules to determine what rules are currently listed by port and service. Next, it adds any missing port/service rules based on inputs from the user via variables. Lastly, it removes any firewall rules that are _not_ listed by the user in their variables. This tag is not currently OS-neutral, but can be with minimal modifications.

### git

This file configures the _system-level_ gitconfig file located in `/etc/gitconfig`. It drops a git commit template, adds your Github username and email to your commit messages, and sets up the autorebase feature for new repos and branches. Autorebase allows for a user to run `git pull upstream --rebase` and automatically rewrite their `git log` to include any new commmits from upstream prior to pushing their latest commits to their origin (aka their fork) of the upstream repo. Assuming that no one else is working on the same features as you and as a result, you will not encounter any merge conflicts during the auto-rebase, this workflow automates the process of staying inline with upstream and keeps your `git log` clean of ugly noop git merges. This file is OS-neutral.

### hub

This file automates the installation and update of the `hub` utility from Github Releases and keeps it on whatever is tagged as "latest". This should be OS-neutral.

### python-packages

This file automates the installation and update of the miscellaneous python-packages passed to it by the user. Currently, the only thing installed globally is `docker-py` so that the docker-related tasks run properly. There are no provisions in the role for adding additional globally-installed python packages, beacause this should be done sparingly, and when it is absolutely required, it should be done via the system package manager, (assuming the pythong module has been packaged). All the package names passed by the user are installed with pip's `--user` option. Also note, python3 is assumed, so unless you do the leg work to ensure your OS is python3 enabled, this tasks file is not OS-neutral. If the OS is python3 enabled, this file is OS-neutral. Ubuntu 18.04 (and later) derived OSes use python3 by default.

### repos

This file adds some repositories used by other tasks to install system packages required by those tasks. It is not OS-neutral.

### terraform

This file installs the latest _non-alpha_ release of Terraform fro Hashicorp's website, performing gpg and hashsum checks along the way. Since terraform is written in Go and precompiled, and dropped in `/usr/local/bin/` this is an OS-neutral tasks file.

### travis

This file installs travis-ci's command-line interface utility via the Ruby `gem` utility and keeps it inline with the latest gem. As a result, the system package that provides the `gem` utility should be included in the dictionary fed to the `system-package.yml` tasks file, or (alternately) it should be installed and maintained via some other mechanism. Assuming `gem` is installed, this file is OS-neutral.

### vagrant

This file installs `vagrant` from Hashicorp's releases website. It scraps the directory structure for what appears to be the latest non-alpha release and installs it each time this tasks file is run. Since Hashicorp provides system packages for vagrant releases, this file installs the .deb package via `gdebi`. As a result, `gdebi` must be available. This tasks file also manages the installation of vagrant plugins passed by the user. This tasks file is _not_ OS-neutral.

### docker-images

This file installs the docker images specified by the user via variables. Since this can suck up some bandwidth, it does not run by default and must be explicitly called. It assumes `docker` is already installed and running. This file is OS_neutral.

### storage

*Warning*: This file has the potential to be extremely destructive, and should only be run on fresh systems, and should only be run once. This has the potential to *wipe drives* and *wipe LVM LVs, VGs, and PVs*. Use with caution. *This task does NOT run by default*. This tasks file is OS-neutral.

### vagrant-boxes

This file installs and updates vagrant boxes specified by the user. The underlying bash script that drives this tasks file, will accept a list of org/box/provider combinations and will attempt to install the latest box available that meets that description. Should that box not already be installed, it installs it. Should it be installed, it updates it, then attempts to prune the older version of the box, if it is not actively being used by a container. It does not remove boxes that are listed not in the variables by the user. Anything manually installed by the user will remain static. This file is OS-neutral. Due to the bandwidth required to execute this task, it does not run by default.
