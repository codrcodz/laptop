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
