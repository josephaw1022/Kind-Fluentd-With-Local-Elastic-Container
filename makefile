.DEFINE_GOAL ?= help


.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Kind

.PHONY: kind-create
kind-create: ## Create a local Kubernetes cluster using Kind.
	@echo "Creating a local Kubernetes cluster using Kind..."
	@kind create cluster --config kind.yaml

.PHONY: kind-delete
kind-delete: ## Delete the local Kubernetes cluster.
	@echo "Deleting the local Kubernetes cluster..."
	@kind delete cluster --name fluentd-point-to-elastic-cluster


##@ Elastic/Kibana
.PHONY: elastic-kibana-local-start
elastic-kibana-local-start: ## Start Elasticsearch and Kibana locally.
	@echo "Starting Kibana locally..."
	@bash elastic-start-local/start.sh


.PHONY: elastic-kibana-local-stop
elastic-kibana-local-stop: ## Stop Elasticsearch and Kibana locally.
	@echo "Stopping Kibana locally..."
	@bash elastic-start-local/stop.sh


.PHONY: elastic-kibana-local-credentials-view
elastic-kibana-local-credentials-view: ## View local Kibana credentials to access the Kibana UI.
	@echo "Fetching Kibana credentials..."
	@ES_PASSWORD=$$(grep '^ES_LOCAL_PASSWORD=' elastic-start-local/.env | cut -d '=' -f2); \
	if [ -z "$$ES_PASSWORD" ]; then \
		echo "Password not found in elastic-start-local/.env"; \
	else \
		echo "Username: elastic"; \
		echo "Password: $$ES_PASSWORD"; \
		ehco "Access Kibana at http://localhost:5601"; \
	fi


##@ Kubernetes Resources 

.PHONY: resources-create
resources-create: ## Create the Kubernetes resources - Fluentd, metrics server, etc... 
	@echo "Creating Kubernetes resources..."
	@kubectl apply -k .

.PHONY: resources-delete
resources-delete: ## Delete the Kubernetes resources - Fluentd, metrics server, etc... 
	@echo "Deleting Kubernetes resources..."
	@kubectl delete -k .