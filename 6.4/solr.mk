.PHONY: create delete reload

# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

$(call check_defined, core)

create:
	solr create_core -c $(core)

delete:
	solr delete -c $(core)

reload:
	curl -s "http://localhost:8983/solr/admin/cores?action=RELOAD&core=$(core)"

default: create
