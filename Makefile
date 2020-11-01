include vars.mk
include contrib/build/makefiles/pkg/base/base.mk
include contrib/build/makefiles/pkg/string/string.mk
include contrib/build/makefiles/pkg/color/color.mk
include contrib/build/makefiles/pkg/functions/functions.mk
include contrib/build/makefiles/targets/buildenv/buildenv.mk
include contrib/build/makefiles/targets/git/git.mk
include contrib/build/makefiles/targets/dev/dev.mk
include contrib/build/makefiles/targets/lxd/lxd.mk
include contrib/build/makefiles/targets/ansible/ansible.mk
include $(patsubst ./%,%,$(filter-out %vars.mk , $(wildcard ./artifacts/*/make/*.mk)))

THIS_FILE := $(firstword $(MAKEFILE_LIST))
SELF_DIR := $(dir $(THIS_FILE))
# launches dockerized dev environment
.PHONY: env
.SILENT: env
env: 
	- $(call print_running_target)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) dev-env
	- $(call print_completed_target)
# launches prestaging env (lxd container)
.PHONY: init
.SILENT: init
init:
	- $(call print_running_target)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) $(LXD_TARGETS)
	- $(call print_completed_target)
.PHONY: pre-staging
.SILENT: pre-staging
pre-staging:
	- $(call print_running_target)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) ansible-pre-staging
	- $(call print_completed_target)	

