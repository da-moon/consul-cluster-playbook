CONSUL_TARGETS:=$(PROJECT_NAME)
ifneq ($(CONTAINER_COUNT),)
CONTAINER_SEQ:=$(shell seq $(CONTAINER_COUNT))
CONSUL_TARGETS = $(CONTAINER_SEQ:%=$(PROJECT_NAME)-%)
endif

CONSUL_CONTAINERS=$(CONSUL_TARGETS:%=lxd-%)
LXD_TARGETS = $(CONSUL_CONTAINERS) 
LXD_LAUNCH_TARGETS = $(CONSUL_TARGETS:%=lxd-launch-%
LXD_START_TARGETS = $(CONSUL_TARGETS:%=lxd-start-%) 
LXD_STOP_TARGETS = $(CONSUL_TARGETS:%=lxd-stop-%) 
LXD_CLEAN_TARGETS = $(CONSUL_TARGETS:%=lxd-clean-%) 

.PHONY: $(LXD_TARGETS)
.SILENT: $(LXD_TARGETS)
$(LXD_TARGETS): lxd-%:lxd-launch-% 
	- $(call print_running_target)
	- $(eval name=$(@:lxd-%=%))
	- $(eval ip=$(shell lxc list --format json | jq -r '.[] | select((.name=="$(name)") and (.status=="Running"))' | jq -r '.state.network.eth0.addresses' | jq -r '.[] | select(.family=="inet").address'))
	- $(call print_running_target, $(name) container IP is '$(ip)')
	- lxc exec '$(name)' -- bash -c 'apt-get update'
	- lxc exec '$(name)' -- bash -c 'apt-get install -yq apt-utils'
	- lxc exec '$(name)' -- bash -c 'apt-get install -yq sudo openssh-server'
	- lxc exec '$(name)' -- bash -c 'sed -i "/.*PasswordAuthentication.*/d" /etc/ssh/sshd_config' 
	- lxc exec '$(name)' -- bash -c 'echo "PasswordAuthentication yes" | tee -a /etc/ssh/sshd_config'
	- lxc exec '$(name)' -- bash -c 'sed -i "/.*PermitRootLogin.*/d" /etc/ssh/sshd_config' 
	- lxc exec '$(name)' -- bash -c 'echo "PermitRootLogin yes" | tee -a /etc/ssh/sshd_config' 
	- lxc exec '$(name)' -- bash -c 'sed -i.bak -e "s/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g" /etc/sudoers' 
	- lxc exec '$(name)' -- bash -c 'useradd -l -G sudo -md /home/$(USER) -s /bin/bash $(USER)' 
	- lxc exec '$(name)' -- bash -c 'echo "$(USER):$(USER)" | chpasswd'
	- lxc exec '$(name)' -- bash -c 'systemctl restart ssh' 
	- lxc exec '$(name)' -- bash -c 'systemctl restart sshd'
	- ssh-keygen -f "$${HOME}/.ssh/known_hosts" -R "$(ip)"
	- echo "$(USER)" | sshpass ssh-copy-id -o StrictHostKeyChecking=no -f $(USER)@$(ip)
	- $(call print_completed_target)
.PHONY: $(LXD_LAUNCH_TARGETS)
.SILENT: $(LXD_LAUNCH_TARGETS)
$(LXD_LAUNCH_TARGETS): 
	- $(call print_running_target)
	- $(eval name=$(@:lxd-launch-%=%))
	- $(call print_running_target, launching a new LXD container with name of $(name) and base image of $(LXC_IMAGE))
	- $(eval command=lxc launch $(LXC_IMAGE) "$(name)")
ifeq ($(PRIVILEGED_CONTAINER_SUPPORT),true)
	- $(eval command=$(command) -c security.privileged=true -c security.nesting=true)
endif
	- $(eval command=$(command) || lxc start "$(name)")
	- @$(MAKE) --no-print-directory \
	 -f $(THIS_FILE) shell cmd="${command}"
ifneq ($(DELAY),)
	- sleep $(DELAY)
endif
	- $(call print_completed_target)

.PHONY: lxd-stop
.SILENT: lxd-stop
lxd-stop:
	- $(call print_running_target)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) $(LXD_STOP_TARGETS)
	- $(call print_completed_target)
.PHONY: $(LXD_STOP_TARGETS)
.SILENT: $(LXD_STOP_TARGETS)
$(LXD_STOP_TARGETS): 
	- $(call print_running_target)
	- $(eval name=$(@:lxd-stop-%=%))
	- $(call print_running_target, stopping $(name) LXD container forcefully)
	- $(eval command=lxc stop $(name) --force || true)
	- @$(MAKE) --no-print-directory \
	 -f $(THIS_FILE) shell cmd="${command}"
	- $(call print_completed_target)
.PHONY: lxd-clean
.SILENT: lxd-clean
lxd-clean:
	- $(call print_running_target)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) $(LXD_CLEAN_TARGETS)
	- $(call print_completed_target)
.PHONY: $(LXD_CLEAN_TARGETS)
.SILENT: $(LXD_CLEAN_TARGETS)
$(LXD_CLEAN_TARGETS):  lxd-clean-%:lxd-stop-%
	- $(call print_running_target)
	- $(eval name=$(@:lxd-clean-%=%))
	- $(call print_running_target, removing $(name) LXD container)
	- $(eval command=lxc delete $(name))
	- @$(MAKE) --no-print-directory \
	 -f $(THIS_FILE) shell cmd="${command}"
	- $(call print_completed_target)
.PHONY: lxd
.SILENT: lxd
lxd: 
	- $(call print_running_target)
	- $(info CONTAINER_NAME >> $(CONTAINER_NAME) )
	- $(info $(LXD_TARGETS))
	- $(info $(LXD_LAUNCH_TARGETS))
	- $(info $(LXD_START_TARGETS))
	- $(call print_completed_target)

