# etebase
[![CI/CD for etebase](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase.yaml/badge.svg)](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase.yaml)
[![Pub Version](https://img.shields.io/pub/v/etebase)](https://pub.dev/packages/etebase)

Dart client library for etebase using FFI bindings with libetebase

## Table of contents

## Features
- A dart API that mirrors the official Rust API (as seen on https://docs.etebase.com/)
- Internally uses dart FFI to invoke the official C API (https://github.com/etesync/libetebase)
- Supports all features that are supported by the C API

## Installation
Simply add etebase to your pubspec.yaml and run dart pub get (or flutter pub get).

```sh
dart pub add dart_pre_commit
```

**Note:** Flutter users should use the `etebase_flutter` package instead.

## Usage
### Initialization and Termination
The part that is special about the dart API is the fact that all etebase operations run within a custom isolate. This
is due to the fact that these operations include network and file I/O, which otherwise would block the main isolate.
Thus, you need to initialize the isolate once in order to make it available for the rest of the application.

In addition, that isolate needs to load the native `[lib]etebase.[so|dll|dylib]` to invoke the native C APIs. As these
library can be located anywhere, depending on your platform and configuration, you need to supply a load method to load
it.

Finally, that isolate needs to be stopped when your application is done. This is required, as the main isolate of your
application will not terminate until the etebase isolate has been terminated as well. Typically, this is done as the
"last step" of your application tear down.

For example, if we assume we are running a Linux machine with the C library installed to `/usr/lib/libetebase.so` and
the `main` will wait for all operations to be executed. The code to initialize and later terminate the library would
look like this:

```dart
import 'dart:ffi';

import 'package:etebase/etebase.dart';

// must be a global or static method
DynamicLibrary _loadLibEtebase() {
  return DynamicLibrary.open('/usr/lib/libetebase.so');
}

Future<void> main() async {
  await Etebase.ensureInitialized(_loadLibEtebase);

  try {
    // your code that uses the library
  } finally {
    await Etebase.terminate();
  }
}
```

### General API usage
Once you have initialized the isolate, you can easily use the API in almost the same way as the rust API. Go to
https://docs.etebase.com/ to get start. If we for example take the sample rust code from the
[signup guide](https://docs.etebase.com/guides/basic_authentication#signup), in dart it would look as follows:

```dart
import "package:etebase/etebase.dart";

// ...

final user = EtebaseUser(username: "username", email: "text@example.com");
final client = await EtebaseClient.create(..., serverUrl);
final etebase = await EtebaseAccount.signup(client, user, "password");
```

## Documentation
