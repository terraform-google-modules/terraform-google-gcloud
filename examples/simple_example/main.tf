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

module "cli" {
  source = "../.."

  platform              = "linux"
  additional_components = ["kubectl", "beta"]

  create_cmd_body  = "services enable youtube.googleapis.com --project ${var.project_id}"
  destroy_cmd_body = "services disable youtube.googleapis.com --project ${var.project_id}"
}

module "cli-disabled" {
  source = "../.."

  platform              = "linux"
  additional_components = ["kubectl", "beta"]

  enabled          = false
  create_cmd_body  = "services enable datastore.googleapis.com --project ${var.project_id}"
  destroy_cmd_body = "services disable datastore.googleapis.com --project ${var.project_id}"
}
