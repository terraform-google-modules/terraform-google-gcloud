# terraform-google-gcloud

This module was generated from [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template/), which by default generates a module that simply creates a GCS bucket. As the module develops, this README should be updated.

The resources/services/activations/deletions that this module will create/trigger are:

- (none)

## Usage

Basic usage of this module is as follows:

```hcl
module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "~> 0.1"

  platform = "linux"
  additional_components = ["kubectl", "beta"]
}

resource "null_resource" "gcloud_version" {
  triggers {
    always = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "${module.cli.gcloud} version"
  }
}

resource "null_resource" "copy_file_to_k8s" {
  triggers {
    always = "${uuid()}"
  }

  provisioner "local-exec" {
    command = "${module.cli.kubectl} cp ..."
  }
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional\_components | Additional gcloud CLI components to install. Defaults to none. Valid value are components listed in `gcloud components list` | list | `<list>` | no |
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

A service account with the following roles must be used to provision
the resources of this module:

- Storage Admin: `roles/storage.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Storage JSON API: `storage-api.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
