# etebase_flutter
[![CI/CD for etebase_flutter](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase_flutter_ci.yaml/badge.svg)](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase_flutter_ci.yaml)
[![Pub Version](https://img.shields.io/pub/v/etebase_flutter)](https://pub.dev/packages/etebase_flutter)

Flutter platform plugins for the dart bindings of libetebase.

## Table of contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  * [Library initialization](#library-initialization)
  * [Linux Platform setup](#linux-platform-setup)
- [Documentation](#documentation)

<small><i><a href='https://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

## Features
- Flutter plugin extension of the [etebase](https://pub.dev/packages/etebase) package.
- Comes with bundled libraries for Android, iOS, macOS, Windows
  - Linux is also supported, via `pkg-config`
- Automatically initializes `etebase` with flutter.

## Installation
Simply add etebase_flutter to your pubspec.yaml and run dart pub get (or flutter pub get).

```sh
dart pub add etebase_flutter
```

**Note:** Pure Dart users should use the `etebase` package instead.

## Usage
### Library initialization
To initialize the library, you don't really need to do anything, as the library is automatically initialized via
`WidgetsFlutterBinding.ensureInitialized()`.

However, you need to create and manage a `EtebaseClient` instance. My recommendation here is to use a dependency
injection, for example `riverpod` to manage the client:

```dart
final etebaseClientProvider = FutureProvider(
  (ref) => EtebaseClient.create('my-client'),
);

// ...

Widget build(BuildContext context, WidgetRef ref) =>
  ref.watch(etebaseClientProvider).when(
    loading: () => const CircularProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
    data: (client) {
      return Text("Client is ready!");
    },
  );
```

For all other information regarding the usage of the library, refer to the [etebase](https://pub.dev/packages/etebase)
package.

### Linux Platform setup
When working with linux, you need to install https://github.com/etesync/libetebase in a way that the `pkg-config` tool
can find the installed library. The compile-process of linux search pkg config for a package named `etebase`. When
deploying a linux application, you need to make sure to bundle the library with your application.

## Documentation
The documentation is available at https://pub.dev/documentation/etebase_flutter/latest/. A basic example can be found at
https://pub.dev/packages/etebase_flutter/example. Also, the `etebase` package itself has additional documentation for
general use of the API.

In addition to that, you can and should refer to the official [Etebase Documentation](https://docs.etebase.com/). As the
API tries to recreate the Rust-API as closely as possible, you can refer to the Rust examples in that documentation.
Most of the samples there can be easily applied to the dart code.

