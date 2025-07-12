import 'package:logging/logging.dart';
import '../../gen/package_metadata.dart' as meta;
import 'collections_logger.dart';
import 'online_logger.dart';

class AccountLogger {
  final Logger _logger;

  AccountLogger([String? prefix])
    : _logger = prefix != null
          ? Logger('${meta.package}.$prefix')
          : Logger(meta.package);

  OnlineLogger get online => OnlineLogger(_logger);

  CollectionsLogger get collection => CollectionsLogger(_logger);

  void login() => _logger.finer('Logging in');

  void signup() => _logger.finer('Signing up');

  void restore() => _logger.finer('Restoring account from storage');

  void fetch() => _logger.finest('Fetching new auth token');

  void saving() => _logger.finest('Saving account to storage');

  void authenticated() => _logger.fine('Authentication successful');

  void logout() => _logger.finer('Logging out');

  void loggedOut() => _logger.finer('Logging successful');
}
