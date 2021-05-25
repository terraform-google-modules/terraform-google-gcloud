/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  base_cmd = "${var.cluster_name} ${var.cluster_location} ${var.project_id} ${var.internal_ip} ${var.use_existing_context}"
}

module "gcloud_kubectl" {
  source                   = "../.."
  module_depends_on        = var.module_depends_on
  additional_components    = var.additional_components
  skip_download            = var.skip_download
  gcloud_sdk_version       = var.gcloud_sdk_version
  enabled                  = var.enabled
  upgrade                  = var.upgrade
  service_account_key_file = var.service_account_key_file

  create_cmd_entrypoint  = "${path.module}/scripts/kubectl_wrapper.sh"
  create_cmd_body        = var.impersonate_service_account == "" ? "${local.base_cmd} ${var.kubectl_create_command}" : "${local.base_cmd} true ${var.impersonate_service_account} ${var.kubectl_create_command}"
  create_cmd_triggers    = var.create_cmd_triggers
  destroy_cmd_entrypoint = "${path.module}/scripts/kubectl_wrapper.sh"
  destroy_cmd_body       = var.impersonate_service_account == "" ? "${local.base_cmd} ${var.kubectl_destroy_command}" : "${local.base_cmd} true ${var.impersonate_service_account} ${var.kubectl_destroy_command}"
}
