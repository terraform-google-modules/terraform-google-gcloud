# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0](https://www.github.com/terraform-google-modules/terraform-google-gcloud/compare/v1.1.1...v2.0.0) (2020-07-10)


### ⚠ BREAKING CHANGES

* gcloud is now downloaded as part of Terraform execution, meaning your Terraform runner needs access to the internet. Alternatively, you can install gcloud out-of-band and set `skip_download` to true.

### Features

* Add a skip_download var to use global gcloud instead ([#22](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/22)) ([756f5e4](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/756f5e4c35189caa60dae804a0d4b0c04bacd67e))
* Add flag for dependency management and associated example. ([58946a6](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/58946a625957b7f27878e4137c694a36ba595df8))
* add flag to disable upgrades and make each instance separate ([14e134a](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/14e134a4dd944978e5f54c2779b7aa77df260b37))
* Add kubectl submodule ([#45](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/45)) ([dd04160](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/dd041606792ca8a2c35db23acb056675448107a9))
* Download gcloud directly in Terraform and allow skipping completely ([#41](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/41)) ([9c1f3b8](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/9c1f3b8e0fb14ed07babd8d03414a90a23ff2662))


### Bug Fixes

* Download additional_components when var.additional_components == 1 ([#43](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/43)) ([9af0423](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/9af0423e80ff46fa093dd39fae69c6fcb95699f5))
* ignore if cache path exists ([#49](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/49)) ([b7f418c](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/b7f418ca581080ceb174b98bdcb63089e6d95758))
* Only download & install when create cmd changes, fixes [#23](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/23) ([f475970](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/f475970cbf0425b4b5a24b808c6ceb747f1f15b3))
* Remove cyclic dependency warnings in gcloud module ([#31](https://www.github.com/terraform-google-modules/terraform-google-gcloud/issues/31)) ([992c7e8](https://www.github.com/terraform-google-modules/terraform-google-gcloud/commit/992c7e830ec00a8d280b2bf30398af929640d957))

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
