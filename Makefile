#
# ansible-bsd-iscsi-target
#

.PHONY: lint # Test YAML syntax
lint:
	@ansible-lint .

.PHONY: help # This help message
help:
	@grep '^.PHONY: .* #' Makefile \
	| awk -F: '/\.PHONY:/ {gsub(".PHONY: ","");gsub("#","\t");print $0}' \
	| expand -t20 \
	| sort
