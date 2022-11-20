import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'etebase_builder/etebase_client_generator.dart';
import 'etebase_builder/etebase_isolate_generator.dart';

Builder etebaseClientBuilder(BuilderOptions options) => LibraryBuilder(
      EtebaseClientGenerator(),
      generatedExtension: '.client.dart',
    );

Builder etebaseIsolateBuilder(BuilderOptions options) => LibraryBuilder(
      EtebaseIsolateGenerator(),
      generatedExtension: '.isolate.dart',
    );
