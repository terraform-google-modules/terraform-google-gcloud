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
  cluster_endpoint       = "https://${data.google_container_cluster.primary.0.endpoint}"
  cluster_ca_certificate = data.google_container_cluster.primary.0.master_auth.0.cluster_ca_certificate
  token                  = data.google_client_config.default.0.access_token
  create_cmd             = var.use_existing_context ? var.kubectl_create_command : "${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} ${var.kubectl_create_command}"
  destroy_cmd            = var.use_existing_context ? var.kubectl_destroy_command : "${local.cluster_endpoint} ${local.token} ${local.cluster_ca_certificate} ${var.kubectl_destroy_command}"
}

data "google_container_cluster" "primary" {
  count    = var.enabled && ! var.use_existing_context ? 1 : 0
  name     = var.cluster_name
  project  = var.project_id
  location = var.cluster_location
}

data "google_client_config" "default" {
  count = var.enabled && ! var.use_existing_context ? 1 : 0
}

module "gcloud_kubectl" {
  source                = "../.."
  module_depends_on     = var.module_depends_on
  additional_components = var.additional_components
  skip_download         = var.skip_download
  gcloud_sdk_version    = var.gcloud_sdk_version
  enabled               = var.enabled
  upgrade               = var.upgrade

  create_cmd_entrypoint  = "${path.module}/scripts/kubectl_wrapper.sh"
  create_cmd_body        = local.create_cmd
  create_cmd_triggers    = var.create_cmd_triggers
  destroy_cmd_entrypoint = "${path.module}/scripts/kubectl_wrapper.sh"
  destroy_cmd_body       = local.destroy_cmd
}
