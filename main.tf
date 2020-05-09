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
  cache_path           = "${path.module}/cache/${random_id.cache.hex}"
  gcloud_tar_path      = "${local.cache_path}/google-cloud-sdk.tar.gz"
  gcloud_bin_path      = "${local.cache_path}/google-cloud-sdk/bin"
  gcloud_bin_abs_path  = abspath(local.gcloud_bin_path)
  components           = join(" ", var.additional_components)

  gcloud              = var.skip_download ? "gcloud" : "${local.gcloud_bin_path}/gcloud"
  gcloud_download_url = var.gcloud_download_url != "" ? var.gcloud_download_url : "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${var.gcloud_sdk_version}-${var.platform}-x86_64.tar.gz"
  jq_platform         = var.platform == "darwin" ? "osx-amd" : var.platform
  jq_download_url     = var.jq_download_url != "" ? var.jq_download_url : "https://github.com/stedolan/jq/releases/download/jq-${var.jq_version}/jq-${local.jq_platform}64"

  create_cmd_bin  = var.skip_download ? var.create_cmd_entrypoint : "${local.gcloud_bin_path}/${var.create_cmd_entrypoint}"
  destroy_cmd_bin = var.skip_download ? var.destroy_cmd_entrypoint : "${local.gcloud_bin_path}/${var.destroy_cmd_entrypoint}"

  wait = length(null_resource.additional_components.*.triggers) + length(
    null_resource.gcloud_auth_service_account_key_file.*.triggers,
    ) + length(null_resource.gcloud_auth_google_credentials.*.triggers,
  ) + length(null_resource.run_command.*.triggers)

  prepare_cache_command                        = "mkdir ${local.cache_path}"
  download_gcloud_command                      = "curl -sL -o ${local.cache_path}/google-cloud-sdk.tar.gz ${local.gcloud_download_url}"
  download_jq_command                          = "curl -sL -o ${local.cache_path}/jq ${local.jq_download_url} && chmod +x ${local.cache_path}/jq"
  decompress_command                           = "tar -xzf ${local.gcloud_tar_path} -C ${local.cache_path} && cp ${local.cache_path}/jq ${local.cache_path}/google-cloud-sdk/bin/"
  upgrade_command                              = "${local.gcloud} components update --quiet"
  additional_components_command                = "${local.gcloud} components install ${local.components} --quiet"
  gcloud_auth_service_account_key_file_command = "${local.gcloud} auth activate-service-account --key-file ${var.service_account_key_file}"
  gcloud_auth_google_credentials_command       = <<-EOT
    printf "%s" "$GOOGLE_CREDENTIALS" > ${local.tmp_credentials_path} &&
    ${local.gcloud} auth activate-service-account --key-file ${local.tmp_credentials_path}
  EOT

}

resource "random_id" "cache" {
  byte_length = 4
}

resource "null_resource" "module_depends_on" {
  count = length(var.module_depends_on) > 0 ? 1 : 0

  triggers = {
    value = length(var.module_depends_on)
  }
}

resource "null_resource" "prepare_cache" {
  count = (var.enabled && ! var.skip_download) ? 1 : 0

  triggers = merge({
    md5                   = md5(var.create_cmd_entrypoint)
    arguments             = md5(var.create_cmd_body)
    prepare_cache_command = local.prepare_cache_command
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = self.triggers.prepare_cache_command
  }

  depends_on = [null_resource.module_depends_on]
}

resource "null_resource" "download_gcloud" {
  count = (var.enabled && ! var.skip_download) ? 1 : 0

  triggers = merge({
    md5                     = md5(var.create_cmd_entrypoint)
    arguments               = md5(var.create_cmd_body)
    download_gcloud_command = local.download_gcloud_command
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = self.triggers.download_gcloud_command
  }

  depends_on = [null_resource.prepare_cache]
}

resource "null_resource" "download_jq" {
  count = (var.enabled && ! var.skip_download) ? 1 : 0

  triggers = merge({
    md5                 = md5(var.create_cmd_entrypoint)
    arguments           = md5(var.create_cmd_body)
    download_jq_command = local.download_jq_command
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = self.triggers.download_jq_command
  }

  depends_on = [null_resource.prepare_cache]
}

resource "null_resource" "decompress" {
  count = (var.enabled && ! var.skip_download) ? 1 : 0

  triggers = merge({
    md5                     = md5(var.create_cmd_entrypoint)
    arguments               = md5(var.create_cmd_body)
    decompress_command      = local.decompress_command
    download_gcloud_command = local.download_gcloud_command
    download_jq_command     = local.download_jq_command
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = self.triggers.decompress_command
  }

  depends_on = [null_resource.download_gcloud, null_resource.download_jq]
}

resource "null_resource" "upgrade" {
  count = (var.enabled && var.upgrade && ! var.skip_download) ? 1 : 0

  depends_on = [null_resource.decompress]

  triggers = merge({
    md5             = md5(var.create_cmd_entrypoint)
    arguments       = md5(var.create_cmd_body)
    upgrade_command = local.upgrade_command
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = self.triggers.upgrade_command
  }
}

resource "null_resource" "additional_components" {
  count      = var.enabled && length(var.additional_components) > 0 ? 1 : 0
  depends_on = [null_resource.upgrade]

  triggers = merge({
    md5                           = md5(var.create_cmd_entrypoint)
    arguments                     = md5(var.create_cmd_body)
    additional_components_command = local.additional_components_command
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = self.triggers.additional_components_command
  }
}

resource "null_resource" "gcloud_auth_service_account_key_file" {
  count      = var.enabled && length(var.service_account_key_file) > 0 ? 1 : 0
  depends_on = [null_resource.upgrade]

  triggers = merge({
    md5                                          = md5(var.create_cmd_entrypoint)
    arguments                                    = md5(var.create_cmd_body)
    gcloud_auth_service_account_key_file_command = local.gcloud_auth_service_account_key_file_command
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = self.triggers.gcloud_auth_service_account_key_file_command
  }
}

resource "null_resource" "gcloud_auth_google_credentials" {
  count      = var.enabled && var.use_tf_google_credentials_env_var ? 1 : 0
  depends_on = [null_resource.upgrade]

  triggers = merge({
    md5                                    = md5(var.create_cmd_entrypoint)
    arguments                              = md5(var.create_cmd_body)
    gcloud_auth_google_credentials_command = local.gcloud_auth_google_credentials_command
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = self.triggers.gcloud_auth_google_credentials_command
  }
}

resource "null_resource" "run_command" {
  count = var.enabled ? 1 : 0

  depends_on = [
    null_resource.module_depends_on,
    null_resource.decompress,
    null_resource.additional_components,
    null_resource.gcloud_auth_google_credentials,
    null_resource.gcloud_auth_service_account_key_file
  ]

  triggers = merge({
    md5                    = md5(var.create_cmd_entrypoint)
    arguments              = md5(var.create_cmd_body)
    create_cmd_entrypoint  = var.create_cmd_entrypoint
    create_cmd_body        = var.create_cmd_body
    destroy_cmd_entrypoint = var.destroy_cmd_entrypoint
    destroy_cmd_body       = var.destroy_cmd_body
    gcloud_bin_abs_path    = local.gcloud_bin_abs_path
  }, var.create_cmd_triggers)

  provisioner "local-exec" {
    when    = create
    command = <<-EOT
    PATH=${self.triggers.gcloud_bin_abs_path}:$PATH
    ${self.triggers.create_cmd_entrypoint} ${self.triggers.create_cmd_body}
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
    PATH=${self.triggers.gcloud_bin_abs_path}:$PATH
    ${self.triggers.destroy_cmd_entrypoint} ${self.triggers.destroy_cmd_body}
    EOT
  }
}

// Destroy provision steps in opposite depdenency order
// so they run before `run_command` destroy
resource "null_resource" "gcloud_auth_google_credentials_destroy" {
  count      = var.enabled && var.use_tf_google_credentials_env_var ? 1 : 0
  depends_on = [null_resource.run_command]

  triggers = {
    gcloud_auth_google_credentials_command = local.gcloud_auth_google_credentials_command
  }
  provisioner "local-exec" {
    when    = destroy
    command = self.triggers.gcloud_auth_google_credentials_command
  }
}

resource "null_resource" "gcloud_auth_service_account_key_file_destroy" {
  count      = var.enabled && length(var.service_account_key_file) > 0 ? 1 : 0
  depends_on = [null_resource.run_command]

  triggers = {
    gcloud_auth_service_account_key_file_command = local.gcloud_auth_service_account_key_file_command
  }

  provisioner "local-exec" {
    when    = destroy
    command = self.triggers.gcloud_auth_service_account_key_file_command
  }
}

resource "null_resource" "additional_components_destroy" {
  count      = var.enabled && length(var.additional_components) > 0 ? 1 : 0
  depends_on = [null_resource.run_command]

  triggers = {
    additional_components_command = local.additional_components_command
  }

  provisioner "local-exec" {
    when    = destroy
    command = self.triggers.additional_components_command
  }
}

resource "null_resource" "upgrade_destroy" {
  count = (var.enabled && var.upgrade && ! var.skip_download) ? 1 : 0

  depends_on = [
    null_resource.additional_components_destroy,
    null_resource.gcloud_auth_service_account_key_file_destroy,
    null_resource.gcloud_auth_google_credentials_destroy
  ]

  triggers = {
    upgrade_command = local.upgrade_command
  }

  provisioner "local-exec" {
    when    = destroy
    command = self.triggers.upgrade_command
  }
}

resource "null_resource" "decompress_destroy" {
  count      = (var.enabled && ! var.skip_download) ? 1 : 0
  depends_on = [null_resource.upgrade_destroy]

  triggers = {
    decompress_command = local.decompress_command
  }

  provisioner "local-exec" {
    when    = destroy
    command = self.triggers.decompress_command
  }
}
