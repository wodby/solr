-include rewrite.mk

.PHONY: waitsolr create delete reload ping

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

$(call check_defined, core, host, port)

config_set ?= data_driven_schema_configs
max_try ?= 12
wait_seconds ?= 5

default: create

create: waitsolr
	curl -sI "http://$(host):$(port)/solr/admin/cores?action=CREATE&name=$(core)&configSet=$(config_set)"

delete: waitsolr
	curl -sI "http://$(host):$(port)/solr/admin/cores?action=UNLOAD&core=$(core)&deleteIndex=true&deleteDataDir=true&deleteInstanceDir=true"

reload: waitsolr
	curl -sI "http://$(host):$(port)/solr/admin/cores?action=RELOAD&core=$(core)"

ping: waitsolr
	curl -sI "http://$(host):$(port)/solr/$(core)/admin/ping"

waitsolr:
	/opt/docker-solr/scripts/wait-solr $(host) $(port) $(max_try) $(wait_seconds)
