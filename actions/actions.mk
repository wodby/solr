.PHONY: init create delete reload ping check-ready check-live

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Required parameter is missing: $1$(if $2, ($2))))

host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 1

# New versions of solr have a different name of the default config set
ifneq ("$(wildcard /opt/docker-solr/configsets/_default)","")
    config_set ?= _default
else
    config_set ?= data_driven_schema_configs
endif

default: create

init:
	init-solr.sh $(host)

# We don't use solr CLI because it does not create configs out of config set.
create:
	$(call check_defined, core)
	echo "Creating core $(core) from config set $(config_set)"
	$(eval instance_dir ?= $(core))
	curl -sIN "http://$(host):8983/solr/admin/cores?action=CREATE&name=$(core)&configSet=$(config_set)&instanceDir=$(instance_dir)" \
		| head -n 1 | awk '{print $$2}' | grep -q 200

delete:
	echo "Deleting core $(core)"
	$(call check_defined, core)
	curl -sIN "http://$(host):8983/solr/admin/cores?action=UNLOAD&core=$(core)&deleteIndex=true&deleteDataDir=true&deleteInstanceDir=true" \
		| head -n 1 | awk '{print $$2}' | grep -q 200

reload:
	$(call check_defined, core)
	echo "Reloading core $(core)"
	curl -sIN "http://$(host):8983/solr/admin/cores?action=RELOAD&core=$(core)" \
		| head -n 1 | awk '{print $$2}' | grep -q 200

ping:
	$(call check_defined, core)
	echo "Pinging core $(core)"
	curl -sIN "http://$(host):8983/solr/$(core)/admin/ping" \
		| head -n 1 | awk '{print $$2}' | grep -q 200

check-ready:
	wait-solr.sh $(host) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
