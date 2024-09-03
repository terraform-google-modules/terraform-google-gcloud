/**
 * Copyright 2024 Google LLC
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

module "network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.0"
  project_id   = var.project_id
  network_name = "asmcli-example-network"

  subnets = [
    {
      subnet_name   = "asmcli-example-subnet"
      subnet_ip     = "10.0.0.0/17"
      subnet_region = "us-central1"
    },
  ]

  secondary_ranges = {
    ("asmcli-example-subnet") = [
      {
        range_name    = "asmcli-example-pods"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "asmcli-example-services"
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}

module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  version                = "~> 32.0"
  project_id             = var.project_id
  name                   = "asmcli-example"
  regional               = true
  region                 = "us-central1"
  network                = module.network.network_name
  subnetwork             = module.network.subnets_names[0]
  ip_range_pods          = "asmcli-example-pods"
  ip_range_services      = "asmcli-example-services"
  create_service_account = true
  deletion_protection    = false
}

module "asmcli" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 3.0"

  platform              = "linux"
  additional_components = ["kubectl"]
  skip_download         = false

  asmcli_version = "1.22"

  create_cmd_entrypoint = "asmcli"
  create_cmd_body       = "install --project_id ${var.project_id} --cluster_name ${module.gke.name} --cluster_location ${module.gke.location} --enable_all --ca mesh_ca"
}

data "google_client_config" "default" {
}
