#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#

NS              ?= kube-system
SERVICE_NAME    ?= kubernetes-dashboard
SERVICE_PORT    ?= 80
export

install:    ingress-install
delete:     ingress-delete
get:        service-account-get cluster-role-get cluster-role-binding-get configmap-get daemonset-get

#
# Find first pod and follow log output
#
logs:

	@$(eval POD:=$(shell kubectl get pods --all-namespaces -lk8s-app=fluentd-logging -o jsonpath='{.items[0].metadata.name}'))
	echo $(POD)

	kubectl --namespace $(NS) logs -f $(POD)

#
# DaemonSet
#
ingress-default-install:

	@echo Installing:
	envsubst < ingress-default.yaml
	@echo --
	envsubst < ingress-default.yaml | kubectl --namespace $(NS) apply -f -

ingress-default-delete:

	envsubst < ingress-default.yaml | kubectl --namespace $(NS) delete -f -


#
# DaemonSet
#
ingress-rules-paths-install:

	@echo Installing:
	envsubst < ingress-rules-paths.yaml
	@echo --
	envsubst < ingress-rules-paths.yaml | kubectl --namespace $(NS) apply -f -

ingress-rules-paths-delete:

	envsubst < ingress-rules-paths.yaml | kubectl --namespace $(NS) delete -f -


#
# Service
#
service-install:

	@echo Installing:
	envsubst < glbc-service.yaml
	@echo --
	envsubst < glbc-service.yaml | kubectl --namespace $(NS) apply -f -

service-delete:

	envsubst < glbc-service.yaml | kubectl --namespace $(NS) delete -f -
