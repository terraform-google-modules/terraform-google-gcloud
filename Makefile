# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.PHONY: gcloud.download gcloud.darwin gcloud.linux clean reset
GCLOUD_SDK_VERSION:=233.0.0

all: reset
all:
	$(MAKE) gcloud.darwin
	$(MAKE) gcloud.linux

gcloud.darwin: OS_ARCH=darwin
gcloud.darwin: gcloud.download

gcloud.linux: OS_ARCH=linux
gcloud.linux: gcloud.download

gcloud.download:
	mkdir -p cache/${OS_ARCH}/
	cd cache/${OS_ARCH}/ && \
		curl -sL -o google-cloud-sdk.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-${OS_ARCH}-x86_64.tar.gz

clean: ## Clean caches of decompressed SDKs
	rm -rf cache/darwin/google-cloud-sdk/
	rm -rf cache/linux/google-cloud-sdk/
	rm -rf cache/darwin/google-cloud-sdk.staging/
	rm -rf cache/linux/google-cloud-sdk.staging/

reset:
	rm -rf cache

docs:
	terraform-docs md ./ | tail -r | tail -n +2 | tail -r
