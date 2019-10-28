/**
 * Copyright 2018 Google LLC
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

variable "create_command" {
  description = "On create, the command you'd like to run with the GCP SDK."
  default     = "true"
}

variable "destroy_command" {
  description = "On destroy, the command you'd like to run with the GCP SDK."
  default     = "true"
}

variable "additional_components" {
  description = "Additional gcloud CLI components to install. Defaults to none. Valid value are components listed in `gcloud components list`"
  default     = []
}

variable "platform" {
  description = "Platform CLI will run on. Defaults to linux. Valid values: linux, darwin"
  default     = "linux"
}

variable "service_account_key_file" {
  description = "Path to service account key file to run `gcloud auth activate-service-account` with. Optional."
  default     = ""
}

variable "use_tf_google_credentials_env_var" {
  description = "Use GOOGLE_CREDENTIALS environment variable to run `gcloud auth activate-service-account` with. Optional."
  default     = false
}
