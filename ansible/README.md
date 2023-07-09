# Ansible usage.

Documentation on how to use `nixos.yml` playbook to keep your configuration up to date on multiple hosts.


**NB! This playbook alone does not do the initial configuration!**

## Setup

Create a suitable file that matches your computers hostname in `host_vars` e.g. `host_vars/tafka-nixos.yml` if your host name under in terminal is:
```
hostname
tafka-nixos
# Or 
cat /etc/hostname
tafka-nixos
```

----