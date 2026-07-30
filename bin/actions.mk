.PHONY: init create create-collection delete reload ping update-password add-admin-user check-ready check-live

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
solr_user ?= solr
solr_password ?= $(if $(SOLR_CLOUD_PASSWORD),$(SOLR_CLOUD_PASSWORD),SolrRocks)
curl_auth = --user "$(solr_user):$(solr_password)"

ifeq ($(config_set),)
    ifneq ($(SOLR_DEFAULT_CONFIG_SET),)
		config_set ?= $(SOLR_DEFAULT_CONFIG_SET)
    # New versions of solr have a different name of the default config set
    else ifneq ("$(wildcard /opt/solr/server/solr/configsets/_default)","")
        config_set ?= _default
    else
        config_set ?= basic_configs
    endif
endif

default: create

init:
	init_solr $(host)

# We don't use solr CLI because it does not create configs out of config set.
create:
	$(call check_defined, core)
	echo "Creating core $(core) from config set $(config_set)"
	$(eval instance_dir ?= $(core))
	@curl --fail-with-body --silent --show-error $(curl_auth) --get "http://$(host):8983/solr/admin/cores" \
		--data-urlencode "action=CREATE" \
		--data-urlencode "name=$(core)" \
		--data-urlencode "configSet=$(config_set)" \
		--data-urlencode "instanceDir=$(instance_dir)"

create-collection:
	$(call check_defined, collection, num_shards, config)
	echo "Creating collection $(collection) with default config"
	@curl --fail-with-body --silent --show-error $(curl_auth) \
		--request POST "http://$(host):8983/api/collections" \
		--header "Content-Type: application/json" \
		--data '{"name":"$(collection)","numShards":$(num_shards),"config":"$(config)"}'

delete:
	echo "Deleting core $(core)"
	$(call check_defined, core)
	@curl --fail-with-body --silent --show-error $(curl_auth) --get "http://$(host):8983/solr/admin/cores" \
		--data-urlencode "action=UNLOAD" \
		--data-urlencode "core=$(core)" \
		--data-urlencode "deleteIndex=true" \
		--data-urlencode "deleteDataDir=true" \
		--data-urlencode "deleteInstanceDir=true"
	rm -rf "/opt/solr/server/solr/$(core)"

reload:
	$(call check_defined, core)
	echo "Reloading core $(core)"
	@curl --fail-with-body --silent --show-error $(curl_auth) --get "http://$(host):8983/solr/admin/cores" \
		--data-urlencode "action=RELOAD" \
		--data-urlencode "core=$(core)"

upgrade:
	upgrade_core $(host)

ping:
	$(call check_defined, core)
	echo "Pinging core $(core)"
	@curl --fail-with-body --silent --show-error $(curl_auth) \
		"http://$(host):8983/solr/$(core)/admin/ping"

update-password:
	$(call check_defined, username, password, new_password)
	@curl -s --user $(username):$(password) http://$(host):8983/api/cluster/security/authentication \
		-H 'Content-type:application/json' -d '{"set-user":{"$(username)":"$(new_password)"}}' | grep -vq 'errorMessages'

add-admin-user:
	$(call check_defined, admin_username, admin_password, user, password)
	@curl -s --user $(admin_username):$(admin_password) http://$(host):8983/solr/admin/authentication \
		-H 'Content-type:application/json' -d '{"set-user":{"$(user)":"$(password)"}}' | grep -vq 'errorMessages'
	@curl -s --user $(admin_username):$(admin_password) http://$(host):8983/solr/admin/authorization \
		-H 'Content-type:application/json' -d '{"set-user-role":{"$(user)": ["admin"]}}' | grep -vq 'errorMessages'

check-ready:
	wait-for-solr.sh --solr-url http://$(host):8983 --max-attempts $(max_try) --wait-seconds $(wait_seconds)

check-live:
	@echo "OK"
