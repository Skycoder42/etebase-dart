# etebase_flutter
[![CI/CD for etebase_flutter](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase_flutter_ci.yaml/badge.svg)](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase_flutter_ci.yaml)
[![Pub Version](https://img.shields.io/pub/v/etebase_flutter)](https://pub.dev/packages/etebase_flutter)

Flutter extensions for the dart implementation of etebase.

## Table of contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)

<small><i><a href='https://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

## Features
- Flutter extensions of the [etebase](https://pub.dev/packages/etebase) package.
- Provides a `FlutterClient` for a zero configuration setup
- Adds support for handling `Color` values with `ItemMetadata`

## Installation
Simply add `etebase_flutter` to your pubspec.yaml and run dart pub get (or flutter pub get).

```sh
dart pub add etebase_flutter
```

**Note:** Pure Dart users should use the `etebase` package instead.

## Usage
To use the library, you will have to create a `FlutterClient` instance. This can be done by using the
`FlutterClient.create` factory. By default, this will connect to the default etebase server (`https://api.etebase.com`)
and initialize Hive for local caching. Both can be configured via optional parameters, but do not have to:

```dart
final client = FlutterClient.create(
  // serverUrl: Uri.https(...),
  // autoInitHive: true,
);
```

For all other information regarding the usage of the library, refer to the
[etebase documentation](https://pub.dev/packages/etebase#general-api-usage).

## Documentation
The documentation is available at https://pub.dev/documentation/etebase_flutter/latest/. A basic example can be found at
https://pub.dev/packages/etebase_flutter/example. Also, the `etebase` package itself has additional documentation for
general use of the API - Check out the [README](https://pub.dev/packages/etebase#general-api-usage) to get started.

In addition to that, you can and should refer to the official [Etebase Documentation](https://docs.etebase.com/). As the
API tries to mimic the JS-API as closely as possible, you can refer to the JavaScript examples in that documentation.
Most of the samples there can be easily applied to the dart code.
