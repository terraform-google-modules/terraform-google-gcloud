# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
