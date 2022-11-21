import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';

@internal
extension DartTypeX on DartType {
  bool get isPointer => this is InterfaceType && element!.name == 'Pointer';

  DartType get asPointer {
    assert(isPointer, 'Type $this is not a pointer');
    return (this as InterfaceType).typeArguments.single;
  }

  TypeReference typeReference({bool stripUrl = false}) => TypeReference(
        (b) {
          b
            ..symbol = element!.name
            ..isNullable = nullabilitySuffix != NullabilitySuffix.none
            ..url =
                stripUrl ? null : element?.library?.location?.components.single;

          final self = this;
          if (self is InterfaceType) {
            b.types.addAll(
              self.typeArguments
                  .map((t) => t.typeReference(stripUrl: stripUrl)),
            );
          }
        },
      );
}
