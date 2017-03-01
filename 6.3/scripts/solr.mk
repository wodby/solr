-include rewrite.mk

host ?= solr
port ?= 8983
config_set ?= data_driven_schema_configs

.PHONY: create delete reload

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

$(call check_defined, core, host, port)

default: create

create:
	curl -sI "http://$(host):$(port)/solr/admin/cores?action=CREATE&name=$(core)&configSet=$(config_set)"

delete:
	curl -sI "http://$(host):$(port)/solr/admin/cores?action=UNLOAD&core=$(core)&deleteIndex=true&deleteDataDir=true&deleteInstanceDir=true"

reload:
	curl -sI "http://$(host):$(port)/solr/admin/cores?action=RELOAD&core=$(core)"

ping:
	curl -sI "http://$(host):$(port)/solr/$(core)/admin/ping"