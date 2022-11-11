import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'etebase_builder/etebase_generator.dart';

Builder etebaseBuilder(BuilderOptions options) => LibraryBuilder(
      EtebaseGenerator(),
      generatedExtension: '.api.dart',
    );
