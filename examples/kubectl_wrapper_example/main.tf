/**
 * Copyright 2020 Google LLC
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

provider "google" {
  version = "~> 3.16.0"
}

locals {
  manifest_path = "${path.module}/manifests"
}

module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 8.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
  ]
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.0"
  project_id   = module.enabled_google_apis.project_id
  network_name = var.network

  subnets = [
    {
      subnet_name   = var.subnetwork
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${var.subnetwork}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}

module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google"
  version                = "~> 9.0"
  project_id             = module.enabled_google_apis.project_id
  name                   = var.cluster_name
  regional               = true
  region                 = var.region
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  create_service_account = true
}

data "google_client_config" "default" {
}

module "kubectl-imperative" {
  source = "../../modules/kubectl-wrapper"

  project_id        = var.project_id
  cluster_name      = module.gke.name
  cluster_location  = module.gke.location
  module_depends_on = [module.gke.endpoint]
  # using --generator for cross compat between 1.18 and lower
  kubectl_create_command  = "kubectl run --generator=run-pod/v1 nginx-imperative --image=nginx"
  kubectl_destroy_command = "kubectl delete pod nginx-imperative"
  skip_download           = true
}

module "kubectl-local-yaml" {
  source = "../../modules/kubectl-wrapper"

  project_id              = var.project_id
  cluster_name            = module.gke.name
  cluster_location        = module.gke.location
  module_depends_on       = [module.kubectl-imperative.wait, module.gke.endpoint]
  kubectl_create_command  = "kubectl apply -f ${local.manifest_path}"
  kubectl_destroy_command = "kubectl delete -f ${local.manifest_path}"
  skip_download           = false
}
