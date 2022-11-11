import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class EtebaseGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    print('#### IT WORKS: $library');
    return '// IT WORKS';
  }
}
