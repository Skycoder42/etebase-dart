# etebase
[![CI/CD for etebase](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase_ci.yaml/badge.svg)](https://github.com/Skycoder42/etebase-dart/actions/workflows/etebase_ci.yaml)
[![Pub Version](https://img.shields.io/pub/v/etebase)](https://pub.dev/packages/etebase)

Dart native client library for etebase and etesync.

## Table of contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
  * [Initialization](#initialization)
  * [General API usage](#general-api-usage)
  * [Synchronous vs Asynchronous client](#synchronous-vs-asynchronous-client)
  * [Disposing and cleanup](#disposing-and-cleanup)
- [Documentation](#documentation)

<small><i><a href='https://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


## Features
- Fully dart native compatible implementation of the [Etebase Protocol](https://docs.etebase.com/protocol-specs/introduction)
  - Based on the official [etebase-js](https://github.com/etesync/etebase-js) JavaScript client, ported to dart
  - 100% feature parity, including websockets and prefetching (which are not supported by the Rust/C API)
  - Written in dart, but uses [sodium](https://pub.dev/packages/sodium) for cryptographic operations, which is a wrapper
  around the native C library
  - Fully tested
    - Nearly 100% unit test coverage
    - Integration and End-To-End-Tests against the official etebase server and with integrated tests against the JS
    client to ensure 100% compatibility with existing implementations
- Supports all dart and flutter platforms, including mobile, desktop and web
- Additional quality-of-life features that integrate with dart
  - Support for reading and writing `Stream`s
  - Custom `ItemMetadata` implementations
  - Automatic user agent detection
  - An efficient caching implementation based on [hive_ce](https://pub.dev/packages/hive_ce)
    - Inspired by the fs cache of the rust implementation, but also supports web via indexed db
- Supports 2 different encryption modes: sync (for small payloads) and async (for large payloads to not block the UI)
  - For more details see below
- Add flutter package ([etebase_flutter](https://pub.dev/packages/etebase_flutter)) for easy use with flutter

## Installation

Simply add `etebase` to your pubspec.yaml and run dart pub get (or flutter pub get).

```bash
dart pub add etebase
```

**Note**: Flutter users should use the `etebase_flutter` package instead.

## Usage
### Initialization
To use the library, you will have to create a `Client` instance. This can be done by using the `Client.create` factory,
which requires the following parameters:

1. `sodium`: An initialized instance of [`SodiumSumo`](https://pub.dev/documentation/sodium/latest/sodium_sumo/SodiumSumo-class.html)
2. `clientName`: The name of the client. Will be used to build the user agent. Can be anything, but should identify your
application or library.
3. `serverUrl` (optional): The URL of the etebase server to connect to. If not specified, the default etebase server
(`https://api.etebase.com`) will be used.

For the `sodium` parameter, you will have to follow the documentation at [sodium](https://pub.dev/packages/sodium#loading-libsodium).

**Note:** When using the library in a flutter application, consider using `etebase_flutter`
instead of this package, as that will greatly simplify the initialization.

Assuming you already obtained an instance of `SodiumSumo`, the initialization would look like below.

```dart
final SodiumSumo sodium = /* ... */;
final client = Client.create(sodium, 'my_client');
```

### General API usage
Once initialized, you can use the library as you would use the JS variant. For example, to login an existing user, list
their calendar collections and then logout again, the code could look as follows:

```dart
final Client client = /* ... */;

final account = await Account.login(
  client,
  userName,
  password,
);

CollectionListResponse<Collection>? listResponse;
do {
  listResponse = await account.collectionManager.list(
    'test1',
    FetchOptions(stoken: listResponse?.stoken),
  );
  for (final collection in listResponse.data) {
    final meta = await collection.getMeta();
    print('Found collection "${meta.name}" (uid: ${collection.uid})');
    print('>> meta:    $meta');
    print('>> content: ${utf8.decode(await collection.getContent())}');
    collection.dispose();
  }
} while (!listResponse.isDone);
```

Check out the [Example](https://pub.dev/packages/etebase/example) for more details.

### Synchronous vs Asynchronous client
The `Client` provides 3 different factories, two of which are `Client.sync` and `Client.async`. The accept the same
parameter, but have one major difference.

A synchronous client executes all *cryptograpic* operations (except key derivation for the login) on the current
isolate. This is usually not a problem, as for normal use cases only small amount of data will be kept in every item,
which means the en/decryption happens fast and will not block the UI.

However, for some usecases you might want to store larger payloads with etebase. In that case encryption of those larger
payloads will take longer, potentially introducing jank in a UI application. In that case, you can use the asynchronous
variant instead. It will spin up a worker isolate and send all data to that isolate so it can then handle encryption.

> **Important:** Do **NOT** use the async variant by default, as the overhead of using the worker isolate will make
> *ALL* operations significantly slower! Also, etebase already uses chunking to split encryption into multiple smaller
> operations, so UI updates can run in between. Additionally, sending data to the isolate is a potential security risk,
> as data needs to be transferred between isolates via darts IPC mechanisms.
>
> TL;DR: Do not use the async variant unless you have proof (i. e. concrete tests on real devices) that indicate the
> synchronous execution is a problem.

The third factory, `Client.createCustom` allows you to create your own, custom `CryptoExecutor`, in case you need a
different concurrency model. For example, you could implement an executor that uses an isolate pool to speed up
execution even more or one that uses JS WebWorks to archive real concurrency on the web. In any case, you should refer
to the [sodium documentation](https://pub.dev/packages/sodium#running-computations-in-a-separate-isolate) on how to
setup isolates for it if you plan to use a custom executor.

### Disposing and cleanup
All items and collections are encrypted in memory. The keys for those are managed by their respective managers and the
items themselves. As all the keys use [`SecureKey`s](https://pub.dev/documentation/sodium/latest/sodium/SecureKey-class.html),
those keys are somewhat protected in memory and are automatically cleared securely from memory, as soon as they are not
referenced anymore. The exception here is the web platform, as it does not support secure memory. For etebase this means
that all keys will eventually be cleared. However, this is coupled to the dart garbage collector and thus keys may stay
in memory longer then needed.

To archive maximum security for the user, you should always dispose items, collections, managers and the account
whenever you do not need them anymore. The following classes have explicit dispose methods that should be called:
- `CryptoExecutor` (only if a custom executor is used)
- `Client`
- `Account`
- `Cache`
- `ItemManager` (all other manager do not need to be disposed)
- `Collection` (including those returned by a list response)
- `Item` (including those returned by a list response)

## Documentation
The documentation is available at https://pub.dev/documentation/etebase/latest/. A basic example can be found at
https://pub.dev/packages/etebase/example.

In addition to that, you can and should refer to the official [Etebase Documentation](https://docs.etebase.com/). As the
API tries to mimic the JS-API as closely as possible, you can refer to the JavaScript examples in that documentation.
Most of the samples there can be easily applied to the dart code.
