# Simple Example

This example illustrates how to use the `gcloud` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The ID of the project in which to provision resources. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bq | Path to bq CLI |
| gcloud | Path to gcloud CLI |
| gcloud\_bin\_path | Path to gcloud bin path for use to locate any other components |
| gsutil | Path to gsutil CLI |
| kubectl | Path to kubectl CLI. Must be installed first using additional_components |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
