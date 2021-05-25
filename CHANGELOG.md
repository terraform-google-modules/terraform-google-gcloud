# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v2.0.3...v2.1.0) (2021-05-08)


### Features

* add ability to impersonate for kubectl-wrapper module ([#91](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/91)) ([0d4e6f3](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/0d4e6f3e69e58e6f94b1d2325c4ea9f7ab68952d))

### [2.0.3](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v2.0.2...v2.0.3) (2020-09-12)


### Bug Fixes

* Add debug options and bump arg num check kubectl wrapper ([#79](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/79)) ([162a4ec](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/162a4ecf02e8fb431db9e23244cd28a6582e2e8d))

### [2.0.2](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v2.0.1...v2.0.2) (2020-09-02)


### Bug Fixes

* Lazy eval data source only if enabled ([#76](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/76)) ([f2c9913](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/f2c9913f7d7e0b0fc7f26c145e2ca85028507e81))

### [2.0.1](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v2.0.0...v2.0.1) (2020-08-13)


### Bug Fixes

* Only instantiate external data resource if module is enabled ([c47859c](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/c47859c14687f5fef4aa961d0754a136c7c153cb))

## [2.0.0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v1.4.1...v2.0.0) (2020-08-12)


### ⚠ BREAKING CHANGES

* The module has been changed to not download gcloud by default. You can override this behavior by setting `skip_download = false` or setting the GCLOUD_TF_DOWNLOAD environment variable to "always".

### Features

* Decoupled the upsert command and destroy command ([#71](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/71)) ([497886c](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/497886c96cec885d5e861b9e4a5f4122e660fd18))
* Skip gcloud download by default. ([#70](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/70)) ([7113d90](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/7113d902a2a6a1a397d903c842b9cce2886c6700))

### [1.4.1](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v1.4.0...v1.4.1) (2020-07-28)


### Bug Fixes

* Remove jq dependency ([#68](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/68)) ([bf68ab8](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/bf68ab894e642e870ab6c8cf72fc15f929d5e943))

## [1.4.0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v1.3.0...v1.4.0) (2020-07-27)


### Features

* **kubectl:** Generate kubeconfig dynamically ([#62](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/62)) ([6501fd8](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/6501fd86c85bafa36d351f8d9c2c4ceb12b7571c))

## [1.3.0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v1.2.0...v1.3.0) (2020-07-19)


### Features

* Allow overriding download behavior using `GCLOUD_TF_DOWNLOAD` environment variable. ([#59](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/59)) ([9041027](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/90410274fbabe1c8ac059bae37d7066ac3c02759))


### Bug Fixes

* Update to allow for usage in ephemeral environments (TFC/TFE) ([#58](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/58)) ([e0595b0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/e0595b04256a2ea81882de676ee32301525f32fe))

## [1.2.0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v1.1.1...v1.2.0) (2020-07-16)


### Features

* only install missing additional_components ([#53](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/53)) ([db6d1a4](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/db6d1a4571720281c232289dda90fa6e8d7edc23))


### Bug Fixes

* Check for binaries in additional_components ([#57](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/57)) ([c399a32](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/c399a32aaacb58d3e5fd36516346d536e5f7e196))

### [1.1.1](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v1.1.0...v1.1.1) (2020-07-01)


### Bug Fixes

* ignore if cache path exists ([#49](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/49)) ([11bfd8d](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/11bfd8d34b72d4931530062e6c7a7afd5c6d8ed3))

## [1.1.0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v1.0.1...v1.1.0) (2020-06-19)


### Features

* Add kubectl submodule ([#45](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/45)) ([a3aad69](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/a3aad69cca8e0f25ad926dd63008e884f3007aff))

### [1.0.1](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v1.0.0...v1.0.1) (2020-05-09)


### Bug Fixes

* Download additional_components when var.additional_components == 1 ([#43](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/43)) ([25b97e3](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/25b97e360828dadfe41d21bc61075e1b13531320))

## [1.0.0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v0.5.1...v1.0.0) (2020-04-15)


### ⚠ BREAKING CHANGES

* gcloud is now downloaded as part of Terraform execution, meaning your Terraform runner needs access to the internet. Alternatively, you can install gcloud out-of-band and set `skip_download` to true.

### Features

* Download gcloud directly in Terraform and allow skipping completely ([#41](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/41)) ([41fe46b](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/41fe46b2f46ee493e1af54738a52ac5c89103482))

### [0.5.1](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v0.5.0...v0.5.1) (2020-02-20)


### Bug Fixes

* Remove cyclic dependency warnings in gcloud module ([#31](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/31)) ([57a4c36](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/57a4c3631a678f4f2882f9a73ece7b6a6a734673))

## [0.5.0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v0.4.0...v0.5.0) (2020-01-30)


### Features

* Add a skip_download var to use global gcloud instead ([#22](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/22)) ([19c2263](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/19c22633292b925bb6e20aadb9552084bbf7fea8))


### Bug Fixes

* Only download & install when create cmd changes, fixes [#23](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/23) ([a57245b](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/a57245b81a9957b7666779f99a7be80ff192a223))

## [Unreleased](https://github.com/terraform-google-modules/terraform-google-gcloud/compare/v0.4.0...master)

## [0.4.0](https://github.com/terraform-google-modules/terraform-google-gcloud/compare/v0.3.0...v0.4.0) - 2020-01-23

### Added

- Added variables for controlling dependency ordering. [#17](https://github.com/terraform-google-modules/terraform-google-gcloud/pull/17)

### Fixed

- On destroy provisioners so gcloud is installed and configured prior to the `destroy_cmd`. Helpful when running each terraform run in a clean environment (eg. terraform cloud). [#11]

## [0.3.0] - 2019-12-21

### Added

- `create_cmd_entrypoint` and `destroy_cmd_entrypoint` variables can now be set to a custom script to run. Prior to running the command the module will prepend the module's bin directory to `PATH`. [#9]
- `create_cmd_triggers` can be set to trigger the `create_cmd` local-exec again. [#9]

## [0.2.0] - 2019-12-18

### Changed

- Updated GCloud SDK to 274.0.0

## [0.1.0] - 2019-11-19

### Added

- Initial release

[0.3.0]: https://github.com/terraform-google-modules/terraform-google-gcloud/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/terraform-google-modules/terraform-google-gcloud/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/terraform-google-modules/terraform-google-gcloud/releases/tag/v0.1.0

[#11]: https://github.com/terraform-google-modules/terraform-google-gcloud/pull/11
[#9]: https://github.com/terraform-google-modules/terraform-google-gcloud/pull/9
