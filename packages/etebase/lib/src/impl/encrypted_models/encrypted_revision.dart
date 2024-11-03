import 'dart:convert';
import 'dart:typed_data';

import 'package:meta/meta.dart';

import '../../api/models/etebase_item_metadata.dart';
import '../crypto/collection_item_crypto_manager.dart';
import '../crypto/crypto_utils.dart';
import '../managers/client.dart';

@internal
typedef Chunk = (String, Uint8List?);

@internal
class EncryptedRevision<TCryptoManager extends CollectionItemCryptoManager> {
  late final String _uid;
  late final Uint8List _meta;
  final bool _deleted;
  final List<Chunk> _chunks = [];

  EncryptedRevision({
    bool deleted = false,
  }) : _deleted = deleted;

  static Future<EncryptedRevision<TCryptoManager>>
      create<TCryptoManager extends CollectionItemCryptoManager>(
    Client client,
    TCryptoManager cryptoManager,
    Uint8List additionalData,
    EtebaseItemMetadata meta,
    Uint8List content,
  ) async {
    final revision = EncryptedRevision();
    await revision._setMeta(client, cryptoManager, additionalData, meta);
    // TODO set content
  }

  Future<EtebaseItemMetadata> _getMeta(
    Client client,
    TCryptoManager cryptoManager,
    Uint8List additionalData,
  ) async {
    final mac = client.coder.base64Decode(_uid);
    final adHash =
        await _calculateAdHash(client, cryptoManager, additionalData);
    return client.coder.decode(
      data,
      EtebaseItemMetadata.fromJson,
    );
  }

  Future<void> _setMeta(
    Client client,
    TCryptoManager cryptoManager,
    Uint8List additionalData,
    EtebaseItemMetadata meta,
  ) async {
    final adHash =
        await _calculateAdHash(client, cryptoManager, additionalData);
    final encMeta = await cryptoManager.encryptDetached(
      client.crypto.bufferPadSmall(client.coder.encode(meta)),
      adHash,
    );
    _meta = encMeta.nonceCipherText;
    _uid = client.coder.base64Encode(encMeta.mac);
  }

  Future<void> _setContent(
    Client client,
    TCryptoManager cryptoManager,
    Uint8List additionalData,
    Uint8List content,
  ) async {}

  Future<Uint8List> _calculateAdHash(
    Client client,
    TCryptoManager cryptoManager,
    Uint8List additionalData,
  ) async {
    final cryptoMac = await cryptoManager.getCryptoMac();
    cryptoMac
      ..update(Uint8List.fromList([if (_deleted) 1 else 0]))
      ..updateWithLenPrefix(additionalData);

    final chunksHash = await cryptoManager.getCryptoMac(withKey: false);
    for (final (chunk, _) in _chunks) {
      chunksHash.update(client.coder.base64Decode(chunk));
    }
    cryptoMac.update(await chunksHash.finalize());

    return cryptoMac.finalize();
  }
}
