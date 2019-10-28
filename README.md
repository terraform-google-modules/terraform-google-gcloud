# terraform-google-gcloud

This module allows you to use gcloud, gsutil, and any gcloud component in Terraform. Sometimes, there isn't Terraform GCP support for a particular feature, or you'd like to do something each time Terraform runs (ie: upload a file to a Kubernetes pod) that lacks Terraform support.

This module *does not* create any resources on GCP itself, rather exposes the GCP SDK to you for usage in null resources & external data resources.

## Usage

Basic usage of this module is as follows:

```hcl
module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 0.1"

  platform = "linux"
  additional_components = ["kubectl", "beta"]

  create_command  = "${module.gcloud.gcloud} version"
  destroy_command = "${module.gcloud.kubectl} cp ..."
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional\_components | Additional gcloud CLI components to install. Defaults to none. Valid value are components listed in `gcloud components list` | list | `<list>` | no |
| create\_command | On create, the command you'd like to run with the GCP SDK. | string | `"true"` | no |
| destroy\_command | On destroy, the command you'd like to run with the GCP SDK. | string | `"true"` | no |
| platform | Platform CLI will run on. Defaults to linux. Valid values: linux, darwin | string | `"linux"` | no |
| service\_account\_key\_file | Path to service account key file to run `gcloud auth activate-service-account` with. Optional. | string | `""` | no |
| use\_tf\_google\_credentials\_env\_var | Use GOOGLE_CREDENTIALS environment variable to run `gcloud auth activate-service-account` with. Optional. | string | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bq | Path to bq CLI |
| gcloud | Path to gcloud CLI |
| gcloud\_bin\_path | Path to gcloud bin path for use to locate any other components |
| gsutil | Path to gsutil CLI |
| kubectl | Path to kubectl CLI. Must be installed first using additional_components |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.0

### Service Account

A service account must be created, along with a key, to use this module.
The service account must have the proper IAM roles for whatever
commands you're running with this module.

### APIs

A project is not required to host resources of this module, since
this module does not create any resources.

However you will likely need a project for your service account
and any resources you'd like to interact with while using this module.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

