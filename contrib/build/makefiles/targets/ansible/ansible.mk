

THIS_FILE := $(firstword $(MAKEFILE_LIST))
SELF_DIR := $(dir $(THIS_FILE))
PRESTAGING_TARGETS = $(CONTAINER_NAME:%=lxd-%)
.PHONY: ansible-pre-staging-init
.SILENT: ansible-pre-staging-init
ansible-pre-staging-init: 
	- $(call print_running_target)
	- echo '[pre-staging-servers]' | tee $(PWD)/inventories/pre-staging/hosts
	- lxc list --format json | \
		jq -r '.[] | select((.name | contains ("$(PROJECT_NAME)")) and (.status=="Running"))' | \
		jq -r '.state.network.eth0.addresses' | \
		jq -r '.[] | select(.family=="inet").address' | \
		tee -a $(PWD)/inventories/pre-staging/hosts
	- sed -i "s/\([[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*\)/\1 ansible_user=$$USER/g" $(PWD)/inventories/pre-staging/hosts
	- $(call print_completed_target)
.PHONY: ansible-pre-staging
.SILENT: ansible-pre-staging
# [ TODO ] => add dep target 'ansible-pre-staging-init'
ansible-pre-staging:  
	- $(call print_running_target)
	- $(eval command=ansible-playbook -i inventories/pre-staging site.yml --limit pre-staging-servers)
ifneq ($(STAGING_VAULT_PASSWORD_FILE),)
	- $(eval command=$(command) --vault-password-file $(STAGING_VAULT_PASSWORD_FILE))
endif
	- $(eval command=$(command) && ansible-playbook -i inventories/pre-staging site.yml --limit pre-staging-clients)
ifneq ($(STAGING_VAULT_PASSWORD_FILE),)
	- $(eval command=$(command) --vault-password-file $(STAGING_VAULT_PASSWORD_FILE))
endif
	- @$(MAKE) --no-print-directory  -f $(THIS_FILE) shell cmd="${command}" 
	- $(call print_completed_target)
