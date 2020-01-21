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
  tmp_credentials_path = "${path.module}/terraform-google-credentials.json"
  cache_path           = "${path.module}/cache/${var.platform}"
  gcloud_tar_path      = "${local.cache_path}/google-cloud-sdk.tar.gz"
  gcloud_bin_path      = "${local.cache_path}/google-cloud-sdk/bin"
  gcloud_bin_abs_path  = abspath(local.gcloud_bin_path)
  components           = join(" ", var.additional_components)

  gcloud  = "${local.gcloud_bin_path}/gcloud"
  gsutil  = "${local.gcloud_bin_path}/gsutil"
  bq      = "${local.gcloud_bin_path}/bq"
  kubectl = "${local.gcloud_bin_path}/kubectl"
  jq      = "${local.gcloud_bin_path}/jq"

  create_cmd_bin  = "${local.gcloud_bin_path}/${var.create_cmd_entrypoint}"
  destroy_cmd_bin = "${local.gcloud_bin_path}/${var.destroy_cmd_entrypoint}"

  wait = length(null_resource.additional_components.*.triggers) + length(
    null_resource.gcloud_auth_service_account_key_file.*.triggers,
    ) + length(null_resource.gcloud_auth_google_credentials.*.triggers,
  ) + length(null_resource.run_command.*.triggers)

  decompress_command                           = "tar -xzf ${local.gcloud_tar_path} -C ${local.cache_path} && cp ${local.cache_path}/jq ${local.cache_path}/google-cloud-sdk/bin/"
  upgrade_command                              = "${local.gcloud} components update --quiet"
  additional_components_command                = "${local.gcloud} components install ${local.components} --quiet"
  gcloud_auth_service_account_key_file_command = "${local.gcloud} auth activate-service-account --key-file ${var.service_account_key_file}"
  gcloud_auth_google_credentials_command       = <<-EOT
    printf "%s" "$GOOGLE_CREDENTIALS" > ${local.tmp_credentials_path} &&
    ${local.gcloud} auth activate-service-account --key-file ${local.tmp_credentials_path}
  EOT

}

resource "null_resource" "module_depends_on" {
  count = length(var.module_depends_on) > 0 ? 1 : 0

  triggers = {
    value = length(var.module_depends_on)
  }
}

resource "null_resource" "decompress" {
  count = var.enabled ? 1 : 0

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = local.decompress_command
  }

  depends_on = [null_resource.module_depends_on]
}

resource "null_resource" "upgrade" {
  count = var.enabled ? 1 : 0

  depends_on = [null_resource.decompress]

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = local.upgrade_command
  }
}

resource "null_resource" "additional_components" {
  count      = var.enabled && length(var.additional_components) > 1 ? 1 : 0
  depends_on = [null_resource.upgrade]

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = local.additional_components_command
  }
}

resource "null_resource" "gcloud_auth_service_account_key_file" {
  count      = var.enabled && length(var.service_account_key_file) > 0 ? 1 : 0
  depends_on = [null_resource.upgrade]

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = local.gcloud_auth_service_account_key_file_command
  }
}

resource "null_resource" "gcloud_auth_google_credentials" {
  count      = var.enabled && var.use_tf_google_credentials_env_var ? 1 : 0
  depends_on = [null_resource.upgrade]

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = local.gcloud_auth_google_credentials_command
  }
}

resource "null_resource" "run_command" {
  count = var.enabled ? 1 : 0

  depends_on = [
    null_resource.decompress,
    null_resource.additional_components,
    null_resource.gcloud_auth_google_credentials,
    null_resource.gcloud_auth_service_account_key_file
  ]

  triggers = merge({
    md5       = md5(var.create_cmd_entrypoint)
    arguments = md5(var.create_cmd_body)
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = <<-EOT
    PATH=${local.gcloud_bin_abs_path}:$PATH
    ${var.create_cmd_entrypoint} ${var.create_cmd_body}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
    PATH=${local.gcloud_bin_abs_path}:$PATH
    ${var.destroy_cmd_entrypoint} ${var.destroy_cmd_body}
    EOT
  }
}

// Destroy provision steps in opposite depdenency order
// so they run before `run_command` destroy
resource "null_resource" "gcloud_auth_google_credentials_destroy" {
  count      = var.enabled && var.use_tf_google_credentials_env_var ? 1 : 0
  depends_on = [null_resource.run_command]

  provisioner "local-exec" {
    when    = destroy
    command = local.gcloud_auth_google_credentials_command
  }
}

resource "null_resource" "gcloud_auth_service_account_key_file_destroy" {
  count      = var.enabled && length(var.service_account_key_file) > 0 ? 1 : 0
  depends_on = [null_resource.run_command]

  provisioner "local-exec" {
    when    = destroy
    command = local.gcloud_auth_service_account_key_file_command
  }
}

resource "null_resource" "additional_components_destroy" {
  count      = var.enabled && length(var.additional_components) > 1 ? 1 : 0
  depends_on = [null_resource.run_command]

  provisioner "local-exec" {
    when    = destroy
    command = local.additional_components_command
  }
}

resource "null_resource" "upgrade_destroy" {
  count = var.enabled ? 1 : 0

  depends_on = [
    null_resource.additional_components_destroy,
    null_resource.gcloud_auth_service_account_key_file_destroy,
    null_resource.gcloud_auth_google_credentials_destroy
  ]

  provisioner "local-exec" {
    when    = destroy
    command = local.upgrade_command
  }
}

resource "null_resource" "decompress_destroy" {
  count      = var.enabled ? 1 : 0
  depends_on = [null_resource.upgrade_destroy]

  provisioner "local-exec" {
    when    = destroy
    command = local.decompress_command
  }
}
