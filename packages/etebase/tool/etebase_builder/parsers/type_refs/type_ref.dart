import 'package:code_builder/code_builder.dart';

import '../../util/types.dart';

abstract class TypeRef {
  TypeReference get publicType;
  TypeReference get transferType;
  TypeReference get ffiType;

  bool get isOutType;
  bool get isListType;
  bool get isPointer;

  factory TypeRef.void$() = VoidTypeRef;
  factory TypeRef.bool() = BoolTypeRef;
  // ignore: avoid_positional_boolean_parameters
  factory TypeRef.int(bool asReturn) = IntTypeRef;
  factory TypeRef.returnSize() = ReturnSizeTypeRef;
  factory TypeRef.string() = StringTypeRef;
  factory TypeRef.dateTime() = DateTimeTypeRef;
  factory TypeRef.stringList() = StringListTypeRef;
  factory TypeRef.byteArray() = ByteArrayTypeRef;
  factory TypeRef.etebaseCollectionAccessLevel() =
      EtebaseCollectionAccessLevelTypeRef;
  factory TypeRef.etebasePrefetchOption() = EtebasePrefetchOptionTypeRef;
  factory TypeRef.etebaseClass(String name) = EtebaseClassTypeRef;
  factory TypeRef.etebaseClassList(String name) = EtebaseClassListTypeRef;
  factory TypeRef.etebaseOutList(String name) = EtebaseOutListTypeRef;
}

mixin _TypeRefDefaults implements TypeRef {
  @override
  bool get isListType => false;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => false;
}

abstract class _SingleTypeRef with _TypeRefDefaults implements TypeRef {
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

class IntTypeRef with _TypeRefDefaults implements TypeRef {
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

class ReturnSizeTypeRef with _TypeRefDefaults implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.UnsignedLong$);

  @override
  TypeReference get publicType => Types.int$;

  @override
  TypeReference get transferType => Types.int$;
}

class StringTypeRef with _TypeRefDefaults implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Char$);

  @override
  TypeReference get publicType => Types.String$;

  @override
  TypeReference get transferType => Types.String$;
}

class DateTimeTypeRef with _TypeRefDefaults implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Int64$);

  @override
  TypeReference get publicType => Types.DateTime$;

  @override
  TypeReference get transferType => Types.DateTime$;
}

class StringListTypeRef with _TypeRefDefaults implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.pointer(Types.Char$));

  @override
  bool get isListType => true;

  @override
  TypeReference get publicType => Types.list(Types.String$);

  @override
  TypeReference get transferType => Types.list(Types.String$);
}

class ByteArrayTypeRef with _TypeRefDefaults implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Void$);

  @override
  bool get isListType => true;

  @override
  TypeReference get publicType => Types.Uint8List$;

  @override
  TypeReference get transferType => Types.Uint8List$;
}

class EtebaseCollectionAccessLevelTypeRef extends _SingleTypeRef {
  EtebaseCollectionAccessLevelTypeRef()
      : super(Types.EtebaseCollectionAccessLevel$);
}

class EtebasePrefetchOptionTypeRef extends _SingleTypeRef {
  EtebasePrefetchOptionTypeRef() : super(Types.EtebasePrefetchOption$);
}

class EtebaseClassTypeRef with _TypeRefDefaults implements TypeRef {
  final String name;

  EtebaseClassTypeRef(this.name);

  @override
  TypeReference get ffiType => Types.pointer(Types.ffi(refer(name)));

  @override
  bool get isPointer => true;

  @override
  TypeReference get publicType => TypeReference((b) => b..symbol = name);

  @override
  TypeReference get transferType => Types.int$;
}

class EtebaseClassListTypeRef with _TypeRefDefaults implements TypeRef {
  final String name;

  EtebaseClassListTypeRef(this.name);

  @override
  TypeReference get ffiType =>
      Types.pointer(Types.pointer(Types.ffi(refer(name))));

  @override
  bool get isListType => true;

  @override
  bool get isPointer => true;

  @override
  TypeReference get publicType =>
      Types.list(TypeReference((b) => b..symbol = name));

  @override
  TypeReference get transferType => Types.list(Types.int$);
}

class EtebaseOutListTypeRef extends EtebaseClassListTypeRef {
  EtebaseOutListTypeRef(super.name);

  TypeReference get publicInnerType => TypeReference((b) => b..symbol = name);

  @override
  bool get isOutType => true;
}
