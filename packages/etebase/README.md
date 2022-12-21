# etebase
[![CI/CD for etebase](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase.yaml/badge.svg)](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase.yaml)
[![Pub Version](https://img.shields.io/pub/v/etebase)](https://pub.dev/packages/etebase)

Dart client library for etebase using FFI bindings with libetebase

## Table of contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  * [Initialization and Termination](#initialization-and-termination)
  * [General API usage](#general-api-usage)
  * [Disposing and cleanup](#disposing-and-cleanup)
- [Documentation](#documentation)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

## Features
- A dart API that mirrors the official Rust API (as seen on https://docs.etebase.com/)
- Internally uses dart FFI to invoke the official C API (https://github.com/etesync/libetebase)
- Supports all features that are supported by the C API

## Installation
Simply add etebase to your pubspec.yaml and run dart pub get (or flutter pub get).

```sh
dart pub add etebase
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

To simplify the usage of the API, the isolate handling is done automatically by the `EtebaseClient` class. When you
create a new instance and no isolate is running yet, it is created. When the last client gets disposed, the isolate
also gets terminated.

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
  Etebase.ensureInitialized(_loadLibEtebase);

  final client = await EtebaseClient.create('my-client'); // uses default server
  try {
    // your code that uses the library
  } finally {
    await client.dispose();
  }
}
```

**Important:** After the client has been disposed, you must not use any managers, collections, items, etc. that belong
to it. Make sure this is the last operation in your code.

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

// ...
await client.dispose();
```

### Disposing and cleanup
By default, the only thing that needs to be disposed of is the `EtebaseClient`. It is required to be disposed as
otherwise the background isolate will never terminate.

Most other classes do have `dispose` methods, but they are optional. They all use automated finalizers that release the
native resources as soon as they get garbage collected. However, if you want to make sure an instance gets cleaned up,
you can manually invoke the `dispose` method.

Also, since the attached native resources are not known by the garbage collector, your application might consume more
memory than desired when not disposing manually. Decide yourself, how memory critical your environment and whether you
should or should not dispose the instances.

## Documentation
The documentation is available at https://pub.dev/documentation/etebase/latest/. A basic example can be found at
https://pub.dev/packages/etebase/example.

In addition to that, you can and should refer to the official [Etebase Documentation](https://docs.etebase.com/). As the
API tries to recreate the Rust-API as closely as possible, you can refer to the Rust examples in that documentation.
Most of the samples there can be easily applied to the dart code.

If you intend on using the low-level C API directly, you can do so as well by importing
`package:etebase/etebase.ffi.dart`. In that case, you can follow the documentation of the C api in the docs mentioned
above.
