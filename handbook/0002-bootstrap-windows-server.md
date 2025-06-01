# Bootstrap Windows Server with Ansible

There are a few additional dependencies to install on the Windows Server.

## Setup Ansible from MacBook

Install `pipx`:

https://pipx.pypa.io/stable/

Install dependencies:

```sh
pipx install-all pipx-lock.json
```

## Setup inventory file

Add the magic DNS name of the Windows server to `hosts.ini`:

```ini
[win_servers]
nuc12 ansible_host=<magic_dns>
```

## Run playbook

```sh
ansible win_servers -m setup
```

```sh
ansible-playbook playbook_win_servers.yml
```
