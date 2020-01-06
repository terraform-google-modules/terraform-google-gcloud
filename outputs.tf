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

output "create_cmd_bin" {
  description = "The full bin path & command used on create"
  value       = local.create_cmd_bin
}

output "destroy_cmd_bin" {
  description = "The full bin path & command used on destroy"
  value       = local.destroy_cmd_bin
}

output "bin_dir" {
  description = "The full bin path of the modules executables"
  value       = local.gcloud_bin_path
}

output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = local.wait
}
