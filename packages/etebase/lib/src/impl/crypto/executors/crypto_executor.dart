import 'dart:async';

import 'package:sodium/sodium_sumo.dart';

import '../../../api/exceptions/crypto_failure.dart';
import 'async_crypto_executor.dart';
import 'sync_crypto_executor.dart';

/// A callback for a synchronous cryptographic operations.
typedef SyncCallback<T> = T Function(SodiumSumo sodium);

/// A callback for a asynchronous cryptographic operations.
typedef AsyncCallback<T> = T Function(
  SodiumSumo sodium,
  List<SecureKey> secureKeys,
  List<KeyPair> keyPairs,
);

/// Defines an service that can run cryptographic operations synchronously and
/// asynchronously, using whatever execution model is preferred.
///
/// **Important:** All of the exec methods must wrap [SodiumException]s with
/// [CryptoFailure]s. You can wrap your invocation via [CryptoFailure.wrap] to
/// achieve this.
abstract interface class CryptoExecutor {
  /// Creates a default instance of a [CryptoExecutor] that executes most
  /// operations synchronously.
  factory CryptoExecutor.sync(SodiumSumo sodium) = SyncCryptoExecutor;

  /// Creates a default instance of a [CryptoExecutor] that executes most
  /// operations asynchronously on a separate isolate.
  ///
  /// **Only available in the dart vm!**
  static Future<CryptoExecutor> async(SodiumSumo sodium) async {
    final executor = AsyncCryptoExecutor(sodium);
    await executor.initialize();
    return executor;
  }

  /// Disposes of the executor and frees underlying resources, if necessary.
  FutureOr<void> dispose();

  /// Runs the specified [callback] synchronously.
  ///
  /// This is intended for fast crypto operations done on small amounts of data,
  /// e. g. key derivation.
  T execSync<T>(SyncCallback<T> callback);

  /// Runs the specified [callback] asynchronously.
  ///
  /// This is intended for crypto operations that will always take a significant
  /// amount of time and would block the UI if run synchronously.
  ///
  /// Implementation should run the callback on a worker isolate if possible.
  /// The [secureKeys] and [keyPairs] are specified separately, as they need
  /// special treatment to be transferred between isolates. Check out the
  /// sodium documentation for more details.
  Future<T> execAsync<T>(
    AsyncCallback<T> callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  });

  /// Runs the specified [callback] either synchronously or asynchronously.
  ///
  /// How to run the callback is up to the implementor. It is used for "normal"
  /// crypto operations, i. e. encryption of data. This data can have any size,
  /// primarily depending on the application itself. Thus, an implementation
  /// should make that decision based on what kind of data is being processed
  /// primarily and how critical non blocking execution is.
  ///
  /// The [secureKeys] and [keyPairs] are specified separately, is case the
  /// execution should be done on a separate isolate. See [execAsync].
  FutureOr<T> exec<T>(
    AsyncCallback<T> callback, {
    List<SecureKey> secureKeys = const [],
    List<KeyPair> keyPairs = const [],
  });
}
