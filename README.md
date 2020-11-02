# consul-cluster-playbook

<p align="center">
  <a href="https://gitpod.io#https://github.com/da-moon/consul-cluster-playbook">
    <img src="https://img.shields.io/badge/open%20in-gitpod-blue?logo=gitpod" alt="Open In GitPod">
  </a>
  <img src="https://img.shields.io/github/languages/code-size/da-moon/consul-cluster-playbook" alt="GitHub code size in bytes">
  <img src="https://img.shields.io/github/commit-activity/w/da-moon/consul-cluster-playbook" alt="GitHub commit activity">
  <img src="https://img.shields.io/github/last-commit/da-moon/consul-cluster-playbook/master" alt="GitHub last commit">
</p>

Cloud agnostic Ansible playbooks used to deploy consul cluster.

## commands

- these playbooks only work when ansible host and remotes are both `debian` based linux distribution and cpu architecture must be `amd64`.
- make sure `jq` and `sshpass` are installed before running make targets.
- `ansible-generate` was used for generating directory structure. i.e

```bash
ansible-generate -i production staging pre-staging -r 00-ansible-controller -p . -a
```

- generate staging and production `ansible-vault` encryption masterkeys and store them in `STAGING_VAULT_PASSWORD_FILE` and `VAULT_PASSWORD_FILE` files (located in `vars.mk`). you can use the following snippet to generate a 16 byte long hex string.

```bash
# => with GNU coreutils 'head'
head -c16 </dev/urandom|xxd -p -u
# => with hexdump
hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random
# => with openssl : 16 bytes (32 hex symbols)
openssl rand -hex 16
```

this master-key is used to encrypt/decrypt secrets and artifacts such as certificates.

- launch bare-bone lxd containers in case you want to run playbook against local pre-staging environment with the following command

  - you can customize lxd base image by changing `LXC_IMAGE` variable in `vars.mk`. default image is `debian/buster`
  - the following make target generates two set of nodes, `server` and `client`, each set with container count of `CONTAINER_COUNT` which you can customize number of containers by changing it. It is recommended to have at least 3 nodes in each set.
  - if you have not installed `lxd`, install `snap` package manager and run `contrib/lxd-init/lxd` script. refer to [`lxd-init-readme`](contrib/lxd-init/README) for more information.

```bash
make -j`nproc` init
```

> `[NOTE]` increase `DELAY` value in `vars.mk` in case container ip was not available when corresponding make target is running.

> `[NOTE]` this make target installs necessary packages for a debian based environment. in case you change the image to a non-debian based distribution, this target will not work.

- run ansible and provision pre-staging environment by running the following command

```bash
make pre-staging
```

> `[NOTE]` this make target automatically updates pre-staging hosts so no need to manually update `inventories/pre-staging/hosts` every time you create/launch pre-staging containers
  
- remove all pre-staging lxd containers

```bash
make -j`nproc` lxd-clean
```

- decrypt gossip encryption key (e.g for prestaging)

```bash
ansible localhost -m debug -a var="gossip_encryption_key" -e "@inventories/pre-staging/group_vars/gossip_encryption_key.yml" --vault-password-file ~/.vault_pass.txt
```

- decrypt consul root token encryption key (e.g for prestaging)

```bash
ansible localhost -m debug -a var="consul_root_token" -e "@inventories/pre-staging/group_vars/consul_root_token.yml" --vault-password-file ~/.vault_pass.txt
```

- decrypt default polict token encryption key (e.g for prestaging)

```bash
ansible localhost -m debug -a var="default_policy_token" -e "@inventories/pre-staging/group_vars/default_policy_token.yml" --vault-password-file ~/.vault_pass.txt
```

default_policy_token

- in case your host machine is a remote server ( lxd is running on remote), use the following snippet on host to redirect all connections to port `8500` to a consul server's container

```bash
iptables -t nat -A PREROUTING -i $(ip link | awk -F: '$0 !~ "lo|vir|wl|lxd|docker|^[^0-9]"{print $2;getline}') -p tcp --dport 8500 -j DNAT --to "$(lxc list --format json | jq -r '.[] | select((.name | contains ("consul")) and (.status=="Running")).state.network.eth0.addresses|.[] | select(.family=="inet").address' | head -n 1):8500"
```
