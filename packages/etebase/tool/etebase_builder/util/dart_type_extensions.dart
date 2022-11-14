import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

@internal
extension DartTypeX on DartType {
  TypeReference get typeReference => TypeReference(
        (b) {
          b
            ..symbol = element!.name
            ..isNullable = nullabilitySuffix != NullabilitySuffix.none;

          final self = this;
          if (self is InterfaceType) {
            b.types.addAll(self.typeArguments.map((t) => t.typeReference));
          }
        },
      );
}
