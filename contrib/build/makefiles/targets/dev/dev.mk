THIS_FILE := $(lastword $(MAKEFILE_LIST))
SELF_DIR := $(dir $(THIS_FILE))
.PHONY: dev
.SILENT: dev
dev: 
	- $(call print_running_target)
	- $(call print_running_target,listing targets defined in contrib/makefiles/targets/dev/dev.mk ...)
	- $(call print_running_target,++ make dev-env)
	- $(call print_running_target,++ make dev-build-env)
	- $(call print_running_target,++ make dev-clean)
	- $(call print_completed_target)

.PHONY: dev-env
.SILENT: dev-env
dev-env: dev-build-env
	- $(call print_running_target)
	- $(call print_completed_target)
.PHONY: dev-build-env
.SILENT: dev-build-env
dev-build-env:
	- $(call print_running_target)
ifneq ($(shell ${WHICH} docker 2>${DEVNUL}),)
ifeq ($(shell docker images -q $(PROJECT_NAME):latest 2>${DEVNUL}),)
	- $(eval command=docker build -t $(PROJECT_NAME):latest $(PWD)/contrib/dev-env)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="${command}"
endif
endif
	- $(call print_completed_target)

.PHONY: dev-clean
.SILENT: dev-clean
dev-clean:
	- $(call print_running_target)
ifneq ($(shell ${WHICH} docker 2>${DEVNUL}),)
	- $(eval command=docker system prune -f)
	- @$(MAKE) --no-print-directory -f $(THIS_FILE) shell cmd="${command}"
endif
	- $(call print_completed_target)
