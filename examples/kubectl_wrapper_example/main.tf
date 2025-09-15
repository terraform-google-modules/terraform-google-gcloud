/**
 * Copyright 2020-2023 Google LLC
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
  manifest_path = "${path.module}/manifests"
}

module "enabled_google_apis" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 18.0"

  project_id                  = var.project_id
  disable_services_on_destroy = false

  activate_apis = [
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "container.googleapis.com",
    "stackdriver.googleapis.com",
    "gkehub.googleapis.com",
    "connectgateway.googleapis.com",
  ]
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 12.0"
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
    (var.subnetwork) = [
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
  version                = "~> 38.0"
  project_id             = module.enabled_google_apis.project_id
  name                   = var.cluster_name
  regional               = true
  region                 = var.region
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  create_service_account = true
  deletion_protection    = false
}

data "google_client_config" "default" {
}

module "kubectl-imperative" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.0"

  project_id              = var.project_id
  cluster_name            = module.gke.name
  cluster_location        = module.gke.location
  module_depends_on       = [module.gke.endpoint]
  kubectl_create_command  = "kubectl run nginx-imperative --image=nginx"
  kubectl_destroy_command = "kubectl delete pod nginx-imperative"
  skip_download           = true
}

module "kubectl-local-yaml" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-wrapper"
  version = "~> 3.0"

  project_id              = var.project_id
  cluster_name            = module.gke.name
  cluster_location        = module.gke.location
  module_depends_on       = [module.kubectl-imperative.wait, module.gke.endpoint]
  kubectl_create_command  = "kubectl apply -f ${local.manifest_path}/nginx.yaml"
  kubectl_destroy_command = "kubectl delete -f ${local.manifest_path}/nginx.yaml"
  skip_download           = false
}

module "fleet" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"
  version = "~> 38.0"

  depends_on = [module.gke]

  project_id   = var.project_id
  cluster_name = module.gke.name
  location     = module.gke.location
}

module "kubectl-fleet-imperative" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-fleet-wrapper"
  version = "~> 3.0"

  membership_name         = module.fleet.cluster_membership_id
  membership_project_id   = module.fleet.project_id
  membership_location     = module.fleet.location
  module_depends_on       = [module.kubectl-local-yaml.wait, module.fleet.wait]
  kubectl_create_command  = "kubectl run nginx-fleet-imperative --image=nginx"
  kubectl_destroy_command = "kubectl delete pod nginx-fleet-imperative"
  skip_download           = false
}

module "kubectl-fleet-local-yaml" {
  source  = "terraform-google-modules/gcloud/google//modules/kubectl-fleet-wrapper"
  version = "~> 3.0"

  membership_name         = module.fleet.cluster_membership_id
  membership_project_id   = module.fleet.project_id
  membership_location     = module.fleet.location
  module_depends_on       = [module.kubectl-fleet-imperative.wait, module.gke.endpoint]
  kubectl_create_command  = "kubectl apply -f ${local.manifest_path}/nginx-fleet.yaml"
  kubectl_destroy_command = "kubectl delete -f ${local.manifest_path}/nginx-fleet.yaml"
  skip_download           = true
}
