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

output "gcloud" {
  description = "Path to gcloud CLI"
  value       = module.cli.gcloud
}

output "bq" {
  description = "Path to bq CLI"
  value       = module.cli.bq
}

output "gsutil" {
  description = "Path to gsutil CLI"
  value       = module.cli.gsutil
}

output "kubectl" {
  description = "Path to kubectl CLI. Must be installed first using additional_components"
  value       = module.cli.kubectl
}

output "gcloud_bin_path" {
  description = "Path to gcloud bin path for use to locate any other components"
  value       = module.cli.gcloud_bin_path
}
