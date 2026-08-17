# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2026-08-17
### Changed
- Updated min sdk version to ^3.13.0
- Updated min flutter version to >=3.47.0
- Updated dependencies

## [2.0.0] - 2025-06-11
- This release is a complete rewrite of the library. Instead of creating dart bindings for the C library, this rewrite
implements the whole etebase protocol in dart. It is heavily based on the JS client and 100% compatible to it. However,
due to the rewrite, it provides a completely different API than older versions.

## [1.1.1] - 2024-03-14
### Changed
- Updated dependencies
- Updated minimum etebase to 1.0.3
- Updated minimum required dart sdk to 3.3.0
- Updated minimum required flutter sdk to 3.19.0
- Updated embedded libetebase to v0.5.6

## [1.1.0] - 2023-07-27
### Added
- Add support for ios simulator on arm and arm64 linux

### Changed
- Update dependencies
- Improve quality of precompiled, embedded etebase binaries
- Update flutter native build files

## [1.0.1] - 2023-01-19
### Changed
- Updated embedded libetebase to v0.5.4

## [1.0.0] - 2023-01-02
### Added
- Initial release

[2.0.1]: https://github.com/Skycoder42/etebase-dart/compare/etebase_flutter-v2.0.0...etebase_flutter-v2.0.1
[2.0.0]: https://github.com/Skycoder42/etebase-dart/compare/etebase_flutter-v1.1.1...etebase_flutter-v2.0.0
[1.1.1]: https://github.com/Skycoder42/etebase-dart/compare/etebase_flutter-v1.1.0...etebase_flutter-v1.1.1
[1.1.0]: https://github.com/Skycoder42/etebase-dart/compare/etebase_flutter-v1.0.1...etebase_flutter-v1.1.0
[1.0.1]: https://github.com/Skycoder42/etebase-dart/compare/etebase_flutter%2Fv1.0.0...etebase_flutter-v1.0.1
[1.0.0]: https://github.com/Skycoder42/etebase-dart/releases/tag/etebase_flutter%2Fv1.0.0
