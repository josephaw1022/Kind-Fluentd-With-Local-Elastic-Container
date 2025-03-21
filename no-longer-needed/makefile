.DEFINE_GOAL ?= help

.PHONY: help
help: ## Display this help message.
	@echo "Available tasks:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-25s %s\n", $$1, $$2}'

.PHONY: kind-create
kind-create: ## Create a local Kubernetes cluster using Kind.
	@echo "Creating a local Kubernetes cluster using Kind..."
	@kind create cluster --config kind.yaml

.PHONY: kind-delete
kind-delete: ## Delete the local Kubernetes cluster.
	@echo "Deleting the local Kubernetes cluster..."
	@kind delete cluster --name elastic-cluster

.PHONY: metrics-server-install
metrics-server-install: ## Install the metrics server.
	@echo "Installing the metrics server..."
	@kubectl apply -k .

.PHONY: metrics-server-uninstall
metrics-server-uninstall: ## Uninstall the metrics server.
	@echo "Uninstalling the metrics server..."
	@kubectl delete -k .

.PHONY: olm-install
olm-install: ## Install the Operator Lifecycle Manager (OLM).
	@echo "Installing the Operator Lifecycle Manager (OLM)..."
	@curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.31.0/install.sh | bash -s v0.31.0


.PHONY: elastic-crds-install
elastic-crds-install: ## Install Elastic CRDs.
	@echo "Installing Elastic CRDs..."
	@kubectl create -f https://download.elastic.co/downloads/eck/2.13.0/crds.yaml

.PHONY: elastic-operator-install
elastic-operator-install: ## Install the Elastic Operator.
	@echo "Installing the Elastic Operator..."
	@kubectl apply -f https://download.elastic.co/downloads/eck/2.13.0/operator.yaml

.PHONY: elastic-operator-uninstall
elastic-operator-uninstall: ## Uninstall the Elastic Operator.
	@echo "Uninstalling the Elastic Operator..."
	@kubectl delete -f https://download.elastic.co/downloads/eck/2.13.0/operator.yaml

.PHONY: elastic-crds-uninstall
elastic-crds-uninstall: ## Uninstall Elastic CRDs.
	@echo "Uninstalling Elastic CRDs..."
	@kubectl delete -f https://download.elastic.co/downloads/eck/2.13.0/crds.yaml


.PHONY: elastic-instance-create
elastic-instance-create: ## Create an ElasticSearch instance.
	@echo "Creating an ElasticSearch instance..."
	@kubectl apply -f elastic-resources.yaml

.PHONY: elastic-instance-delete
elastic-instance-delete: ## Delete the ElasticSearch instance.
	@echo "Deleting the ElasticSearch instance..."
	@kubectl delete -f elastic-resources.yaml



.PHONY: quick-start
quick-start: ## Run the quick start for the ElasticSearch operator.
	@echo "Running the quick start..."
	@$(MAKE) kind-create
	@$(MAKE) olm-install
	@$(MAKE) metrics-server-install
	@$(MAKE) elastic-crds-install
	@$(MAKE) elastic-operator-install
	@$(MAKE) elastic-instance-create

.PHONY: quick-stop
quick-stop: ## Stop the quick start and clean up resources.
	@echo "Stopping the quick start..."
	@$(MAKE) kind-delete