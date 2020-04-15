# terraform-google-gcloud

This module allows you to use gcloud, gsutil, any gcloud component, and jq in Terraform. Sometimes, there isn't Terraform GCP support for a particular feature, or you'd like to do something each time Terraform runs (ie: upload a file to a Kubernetes pod) that lacks Terraform support.

This module *does not* create any resources on GCP itself, rather exposes the GCP SDK to you for usage in null resources & external data resources.

## Usage

Basic usage of this module is as follows:

```hcl
module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 1.0"

  platform = "linux"
  additional_components = ["kubectl", "beta"]

  create_cmd_entrypoint  = "gcloud"
  create_cmd_body        = "version"
  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = "version"
}
```

Functional examples are included in the
[examples](./examples/) directory.

The [jq](https://stedolan.github.io/jq/) binary is also included in this module so you can use it as well for either of your `create_cmd_entrypoint` or `destroy_cmd_entrypoint` values.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional\_components | Additional gcloud CLI components to install. Defaults to none. Valid value are components listed in `gcloud components list` | list | `<list>` | no |
| create\_cmd\_body | On create, the command body you'd like to run with your entrypoint. | string | `"info"` | no |
| create\_cmd\_entrypoint | On create, the command entrypoint you'd like to use. Can also be set to a custom script. Module's bin directory will be prepended to path. | string | `"gcloud"` | no |
| create\_cmd\_triggers | List of any additional triggers for the create command execution. | map | `<map>` | no |
| destroy\_cmd\_body | On destroy, the command body you'd like to run with your entrypoint. | string | `"info"` | no |
| destroy\_cmd\_entrypoint | On destroy, the command entrypoint you'd like to use.  Can also be set to a custom script. Module's bin directory will be prepended to path. | string | `"gcloud"` | no |
| enabled | Flag to optionally disable usage of this module. | bool | `"true"` | no |
| gcloud\_download\_url | Custom gcloud download url. Optional. | string | `""` | no |
| gcloud\_sdk\_version | The gcloud sdk version to download. | string | `"281.0.0"` | no |
| jq\_download\_url | Custom jq download url. Optional. | string | `""` | no |
| jq\_version | The jq version to download. | string | `"1.6"` | no |
| module\_depends\_on | List of modules or resources this module depends on. | list | `<list>` | no |
| platform | Platform CLI will run on. Defaults to linux. Valid values: linux, darwin | string | `"linux"` | no |
| service\_account\_key\_file | Path to service account key file to run `gcloud auth activate-service-account` with. Optional. | string | `""` | no |
| skip\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | bool | `"false"` | no |
| upgrade | Whether to upgrade gcloud at runtime | bool | `"true"` | no |
| use\_tf\_google\_credentials\_env\_var | Use GOOGLE_CREDENTIALS environment variable to run `gcloud auth activate-service-account` with. Optional. | string | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| bin\_dir | The full bin path of the modules executables |
| create\_cmd\_bin | The full bin path & command used on create |
| destroy\_cmd\_bin | The full bin path & command used on destroy |
| wait | An output to use when you want to depend on cmd finishing |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.0
- [curl][curl]

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
[curl]: https://curl.haxx.se
