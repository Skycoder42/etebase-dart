import 'package:code_builder/code_builder.dart';

import '../util/types.dart';

abstract class TypeRef {
  TypeReference get publicType;
  TypeReference get transferType;
  TypeReference get ffiType;

  factory TypeRef.void$() = VoidTypeRef;
  factory TypeRef.bool() = BoolTypeRef;
  // ignore: avoid_positional_boolean_parameters
  factory TypeRef.int(bool asReturn) = IntTypeRef;
  factory TypeRef.returnSize() = ReturnSizeTypeRef;
  factory TypeRef.string() = StringTypeRef;
  factory TypeRef.dateTime() = DateTimeTypeRef;
  factory TypeRef.stringList() = StringListTypeRef;
  factory TypeRef.byteArray({bool optional}) = ByteArrayTypeRef;
  factory TypeRef.etebaseCollectionAccessLevel() =
      EtebaseCollectionAccessLevelTypeRef;
  factory TypeRef.etebasePrefetchOption() = EtebasePrefetchOptionTypeRef;
  factory TypeRef.etebaseClass(String name, {bool optional}) =
      EtebaseClassTypeRef;
  factory TypeRef.etebaseClassList(String name) = EtebaseClassListTypeRef;
  factory TypeRef.etebaseOutList(String name) = EtebaseOutListTypeRef;
}

abstract class _SingleTypeRef implements TypeRef {
  final TypeReference _type;

  _SingleTypeRef(this._type);

  @override
  TypeReference get ffiType => _type;

  @override
  TypeReference get publicType => _type;

  @override
  TypeReference get transferType => _type;
}

class VoidTypeRef extends _SingleTypeRef {
  VoidTypeRef() : super(Types.void$);
}

class BoolTypeRef extends _SingleTypeRef {
  BoolTypeRef() : super(Types.bool$);
}

class IntTypeRef implements TypeRef {
  final bool asReturn;

  // ignore: avoid_positional_boolean_parameters
  IntTypeRef(this.asReturn);

  @override
  TypeReference get ffiType => Types.int$;

  @override
  TypeReference get publicType => asReturn ? Types.void$ : Types.int$;

  @override
  TypeReference get transferType => asReturn ? Types.void$ : Types.int$;
}

class ReturnSizeTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.UnsignedLong$);

  @override
  TypeReference get publicType => Types.int$;

  @override
  TypeReference get transferType => Types.int$;
}

class StringTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Char$);

  @override
  TypeReference get publicType => Types.String$;

  @override
  TypeReference get transferType => Types.String$;
}

class DateTimeTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Int64$);

  @override
  TypeReference get publicType => Types.DateTime$;

  @override
  TypeReference get transferType => Types.DateTime$;
}

class StringListTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.pointer(Types.Char$));

  @override
  TypeReference get publicType => Types.list(Types.String$);

  @override
  TypeReference get transferType => Types.list(Types.String$);
}

class ByteArrayTypeRef implements TypeRef {
  final bool optional;

  ByteArrayTypeRef({this.optional = false});

  @override
  TypeReference get ffiType => Types.pointer(Types.Void$);

  @override
  TypeReference get publicType =>
      optional ? Types.Uint8List$.asNullable : Types.Uint8List$;

  @override
  TypeReference get transferType => optional
      ? Types.TransferableTypedData$.asNullable
      : Types.TransferableTypedData$;
}

class EnumTypeRef extends _SingleTypeRef {
  EnumTypeRef(super.type);

  @override
  TypeReference get ffiType => Types.int$;
}

class EtebaseCollectionAccessLevelTypeRef extends EnumTypeRef {
  EtebaseCollectionAccessLevelTypeRef()
      : super(Types.EtebaseCollectionAccessLevel$);
}

class EtebasePrefetchOptionTypeRef extends EnumTypeRef {
  EtebasePrefetchOptionTypeRef() : super(Types.EtebasePrefetchOption$);
}

class EtebaseClassTypeRef implements TypeRef {
  final String name;
  final bool optional;

  EtebaseClassTypeRef(this.name, {this.optional = false});

  @override
  TypeReference get ffiType => Types.pointer(Types.ffi(refer(name)));

  @override
  TypeReference get publicType => TypeReference(
        (b) => b
          ..symbol = name
          ..isNullable = optional,
      );

  @override
  TypeReference get transferType =>
      optional ? Types.int$.asNullable : Types.int$;
}

class EtebaseClassListTypeRef implements TypeRef {
  final String name;

  EtebaseClassListTypeRef(this.name);

  TypeReference get publicInnerType => TypeReference((b) => b..symbol = name);

  TypeReference get ffiInnerType => Types.pointer(Types.ffi(refer(name)));

  @override
  TypeReference get ffiType => Types.pointer(ffiInnerType);

  @override
  TypeReference get publicType => Types.list(publicInnerType);

  @override
  TypeReference get transferType => Types.list(Types.int$);
}

class EtebaseOutListTypeRef extends EtebaseClassListTypeRef {
  EtebaseOutListTypeRef(super.name);
}
