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
  components           = join(" ", var.additional_components)
}

data "null_data_source" "values" {
  depends_on = [null_resource.decompress]

  inputs = {
    gcloud  = "${local.gcloud_bin_path}/gcloud"
    gsutil  = "${local.gcloud_bin_path}/gsutil"
    bq      = "${local.gcloud_bin_path}/bq"
    kubectl = "${local.gcloud_bin_path}/kubectl"
  }
}

resource "null_resource" "decompress" {
  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = "tar -xzf ${local.gcloud_tar_path} -C ${local.cache_path}"
  }
}

resource "null_resource" "upgrade" {
  depends_on = [data.null_data_source.values]

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = "${data.null_data_source.values.outputs["gcloud"]} components update --quiet"
  }
}

resource "null_resource" "additional_components" {
  count      = length(var.additional_components) > 1 ? 1 : 0
  depends_on = [null_resource.upgrade]

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = "${data.null_data_source.values.outputs["gcloud"]} components install ${local.components} --quiet"
  }
}

resource "null_resource" "gcloud_auth_service_account_key_file" {
  count      = length(var.service_account_key_file) > 0 ? 1 : 0
  depends_on = [null_resource.upgrade]

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = "${data.null_data_source.values.outputs["gcloud"]} auth activate-service-account --key-file ${var.service_account_key_file}"
  }
}

resource "null_resource" "gcloud_auth_google_credentials" {
  count      = var.use_tf_google_credentials_env_var ? 1 : 0
  depends_on = [null_resource.upgrade]

  triggers = {
    always = uuid()
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
printf "%s" "$GOOGLE_CREDENTIALS" > ${local.tmp_credentials_path} &&
${data.null_data_source.values.outputs["gcloud"]} auth activate-service-account --key-file ${local.tmp_credentials_path}
EOF
  }
}
