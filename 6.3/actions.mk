.PHONY: create delete reload ping check-ready check-live

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Required parameter is missing: $1$(if $2, ($2))))

host ?= localhost
config_set ?= data_driven_schema_configs
max_try ?= 1
wait_seconds ?= 1

default: create

create:
	$(call check_defined, core)
	curl -sIN "http://$(host):8983/solr/admin/cores?action=CREATE&name=$(core)&configSet=$(config_set)" \
		| head -n 1 | awk '{print $$2}' | grep 200

delete:
	$(call check_defined, core)
	curl -sIN "http://$(host):8983/solr/admin/cores?action=UNLOAD&core=$(core)&deleteIndex=true&deleteDataDir=true&deleteInstanceDir=true" \
		| head -n 1 | awk '{print $$2}' | grep 200

reload:
	$(call check_defined, core)
	curl -sIN "http://$(host):8983/solr/admin/cores?action=RELOAD&core=$(core)" \
		| head -n 1 | awk '{print $$2}' | grep 200

ping:
	$(call check_defined, core)
	curl -sIN "http://$(host):8983/solr/$(core)/admin/ping" \
		| head -n 1 | awk '{print $$2}' | grep 200

check-ready:
	/opt/docker-solr/scripts/wait-solr $(host) $(max_try) $(wait_seconds)

check-live:
	@echo "OK"
