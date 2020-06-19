# kubectl wrapper

This submodule aims to make interactions with GKE clusters using kubectl easier by utilizing the gcloud module and kubectl_wrapper script.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional\_components | Additional gcloud CLI components to install. Defaults to installing kubectl. Valid value are components listed in `gcloud components list` | list | `<list>` | no |
| cluster\_location | Cluster location (Zone/Region) | string | n/a | yes |
| cluster\_name | Cluster name | string | n/a | yes |
| create\_cmd\_triggers | List of any additional triggers for the create command execution. | map | `<map>` | no |
| enabled | Flag to optionally disable usage of this module. | bool | `"true"` | no |
| gcloud\_sdk\_version | The gcloud sdk version to download. | string | `"281.0.0"` | no |
| kubectl\_create\_command | The kubectl command to create resources. | string | n/a | yes |
| kubectl\_destroy\_command | The kubectl command to destroy resources. | string | n/a | yes |
| module\_depends\_on | List of modules or resources this module depends on. | list | `<list>` | no |
| project\_id | The project ID hosting the cluster | string | n/a | yes |
| skip\_download | Whether to skip downloading gcloud (assumes gcloud and kubectl is already available outside the module) | bool | `"false"` | no |
| upgrade | Whether to upgrade gcloud at runtime | bool | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bin\_dir | The full bin path of the modules executables |
| create\_cmd\_bin | The full bin path & command used on create |
| destroy\_cmd\_bin | The full bin path & command used on destroy |
| wait | An output to use when you want to depend on cmd finishing |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
