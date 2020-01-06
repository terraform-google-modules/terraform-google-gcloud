# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Please note that this file was generated from [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template).
# Please make sure to contribute relevant changes upstream!

# Make will use bash instead of sh
SHELL := /usr/bin/env bash

GCLOUD_SDK_VERSION := $(shell cat SDK_VERSION)
JQ_VERSION := 1.6
DOCKER_TAG_VERSION_DEVELOPER_TOOLS := 0
DOCKER_IMAGE_DEVELOPER_TOOLS := cft/developer-tools
REGISTRY_URL := gcr.io/cloud-foundation-cicd

# Enter docker container for local development
.PHONY: docker_run
docker_run:
	docker run --rm -it \
		-e SERVICE_ACCOUNT_JSON \
		-v "$(CURDIR)":/workspace \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/bin/bash

# Execute prepare tests within the docker container
.PHONY: docker_test_prepare
docker_test_prepare:
	docker run --rm -it \
		-e SERVICE_ACCOUNT_JSON \
		-e TF_VAR_org_id \
		-e TF_VAR_folder_id \
		-e TF_VAR_billing_account \
		-v "$(CURDIR)":/workspace \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/usr/local/bin/execute_with_credentials.sh prepare_environment

# Clean up test environment within the docker container
.PHONY: docker_test_cleanup
docker_test_cleanup:
	docker run --rm -it \
		-e SERVICE_ACCOUNT_JSON \
		-e TF_VAR_org_id \
		-e TF_VAR_folder_id \
		-e TF_VAR_billing_account \
		-v "$(CURDIR)":/workspace \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/usr/local/bin/execute_with_credentials.sh cleanup_environment

# Execute integration tests within the docker container
.PHONY: docker_test_integration
docker_test_integration:
	docker run --rm -it \
		-e SERVICE_ACCOUNT_JSON \
		-v "$(CURDIR)":/workspace \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/usr/local/bin/test_integration.sh


# Execute lint tests within the docker container
.PHONY: docker_test_lint
docker_test_lint:
	docker run --rm -it \
    -e "EXCLUDE_LINT_DIRS=\./cache" \
		-v "$(CURDIR)":/workspace \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/usr/local/bin/test_lint.sh

# Generate documentation
.PHONY: docker_generate_docs
docker_generate_docs:
	docker run --rm -it \
		-v "$(CURDIR)":/workspace \
		$(REGISTRY_URL)/${DOCKER_IMAGE_DEVELOPER_TOOLS}:${DOCKER_TAG_VERSION_DEVELOPER_TOOLS} \
		/bin/bash -c 'source /usr/local/bin/task_helper_functions.sh && generate_docs'

# Alias for backwards compatibility
.PHONY: generate_docs
generate_docs: docker_generate_docs

.PHONY: all
all: reset
all:
	$(MAKE) gcloud.darwin
	$(MAKE) gcloud.linux
	$(MAKE) jq.download

.PHONY: gcloud.darwin
gcloud.darwin: OS_ARCH=darwin
gcloud.darwin: gcloud.download

.PHONY: gcloud.linux
gcloud.linux: OS_ARCH=linux
gcloud.linux: gcloud.download

.PHONY: gcloud.download
gcloud.download:
	mkdir -p cache/${OS_ARCH}/
	cd cache/${OS_ARCH}/ && \
		curl -sL -o google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-${OS_ARCH}-x86_64.tar.gz

.PHONY: jq.download
jq.download:
	mkdir -p cache/darwin/
	cd cache/darwin/ && \
		curl -sL -o jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-osx-amd64 && \
		chmod +x jq
	mkdir -p cache/linux/
	cd cache/linux/ && \
		curl -sL -o jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
		chmod +x jq

.PHONY: clean
clean: ## Clean caches of decompressed SDKs
	rm -rf cache/darwin/google-cloud-sdk/
	rm -rf cache/linux/google-cloud-sdk/
	rm -rf cache/darwin/google-cloud-sdk.staging/
	rm -rf cache/linux/google-cloud-sdk.staging/
	rm -rf cache/darwin/jq
	rm -rf cache/linux/jq

.PHONY: reset
reset:
	rm -rf cache

.PHONY: update-gcloud-version
update-gcloud-version:
	mkdir -p tmp && cd tmp && \
		curl -sL -o google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz && \
		tar -xzf google-cloud-sdk.tar.gz -C . && \
		cp google-cloud-sdk/VERSION ../SDK_VERSION
