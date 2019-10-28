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
  value       = "${data.null_data_source.values.outputs["gcloud"]}"
}

output "bq" {
  description = "Path to bq CLI"
  value       = "${data.null_data_source.values.outputs["bq"]}"
}

output "gsutil" {
  description = "Path to gsutil CLI"
  value       = "${data.null_data_source.values.outputs["gsutil"]}"
}

output "kubectl" {
  description = "Path to kubectl CLI. Must be installed first using additional_components"
  value       = "${data.null_data_source.values.outputs["kubectl"]}"
}

output "gcloud_bin_path" {
  description = "Path to gcloud bin path for use to locate any other components"
  value       = "${local.gcloud_bin_path}"
}
