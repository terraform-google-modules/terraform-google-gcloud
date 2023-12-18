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

locals {
  filename = abspath("${path.module}/file-${random_pet.filename.id}.txt")
}

resource "random_pet" "filename" {
  keepers = {
    always = uuid()
  }
}

module "hello" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform      = "linux"
  upgrade       = false
  skip_download = true

  create_cmd_entrypoint = "${path.module}/scripts/script.sh"
  create_cmd_body       = "${local.filename} hello"
}

module "two" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform      = "linux"
  upgrade       = false
  skip_download = true

  create_cmd_entrypoint = "${path.module}/scripts/script.sh"
  create_cmd_body       = "${local.filename} two"
}

module "goodbye" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform      = "linux"
  upgrade       = false
  skip_download = true

  create_cmd_entrypoint = "${path.module}/scripts/script.sh"
  create_cmd_body       = "${local.filename} goodbye"

  module_depends_on = [
    module.hello.wait,
    module.two.wait
  ]
}
