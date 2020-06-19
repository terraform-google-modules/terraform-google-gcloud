# Kubernetes Wrapper Example

This example illustrates how to use the kubectl submodule to deploy Kubernetes resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster\_name | The name for the GKE cluster | string | `"gke-on-vpc-cluster"` | no |
| ip\_range\_pods\_name | The secondary ip range to use for pods | string | `"ip-range-pods"` | no |
| ip\_range\_services\_name | The secondary ip range to use for services | string | `"ip-range-scv"` | no |
| network | The VPC network created to host the cluster in | string | `"gke-network"` | no |
| project\_id | The project ID to host the cluster in | string | n/a | yes |
| region | The region to host the cluster in | string | `"us-central1"` | no |
| subnetwork | The subnetwork created to host the cluster in | string | `"gke-subnet"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | The cluster ca certificate (base64 encoded) |
| client\_token | The bearer token for auth |
| cluster\_name | Cluster name |
| kubernetes\_endpoint | The cluster endpoint |
| network\_name | The name of the VPC being created |
| service\_account | The default service account used for running nodes. |
| subnet\_name | The name of the subnet being created |
| subnet\_secondary\_ranges | The secondary ranges associated with the subnet |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
