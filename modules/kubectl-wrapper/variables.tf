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

variable "project_id" {
  type        = string
  description = "The project ID hosting the cluster. Optional if use_existing_context is true."
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "Cluster name. Optional if use_existing_context is true."
  default     = ""
}

variable "cluster_location" {
  type        = string
  description = "Cluster location (Zone/Region). Optional if use_existing_context is true."
  default     = ""
}

variable "kubectl_create_command" {
  type        = string
  description = "The kubectl command to create resources."
}

variable "kubectl_destroy_command" {
  type        = string
  description = "The kubectl command to destroy resources."
}

variable "enabled" {
  description = "Flag to optionally disable usage of this module."
  type        = bool
  default     = true
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "create_cmd_triggers" {
  description = "List of any additional triggers for the create command execution."
  type        = map
  default     = {}
}

variable "additional_components" {
  description = "Additional gcloud CLI components to install. Defaults to installing kubectl. Valid value are components listed in `gcloud components list`"
  default     = ["kubectl"]
}

variable "skip_download" {
  description = "Whether to skip downloading gcloud (assumes gcloud and kubectl is already available outside the module)"
  type        = bool
  default     = true
}

variable "gcloud_sdk_version" {
  description = "The gcloud sdk version to download."
  default     = "281.0.0"
}

variable "upgrade" {
  description = "Whether to upgrade gcloud at runtime"
  type        = bool
  default     = true
}

variable "use_existing_context" {
  description = "Use existing kubecontext to auth kube-api."
  type        = bool
  default     = false
}

variable "internal_ip" {
  description = "Use internal ip for the cluster endpoint."
  type        = bool
  default     = false
}

variable "service_account_key_file" {
  description = "Path to service account key file to auth as for running `gcloud container clusters get-credentials`."
  default     = ""
}

variable "impersonate_service_account" {
  type        = string
  description = "An optional service account to impersonate for gcloud commands. If this service account is not specified, the module will use Application Default Credentials."
  default     = ""
}
