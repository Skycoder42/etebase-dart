import 'package:code_builder/code_builder.dart';

import '../../util/types.dart';

abstract class TypeRef {
  TypeReference get publicType;
  TypeReference get transferType;
  TypeReference get ffiType;

  bool get isOutType;
  bool get isListType;
  bool get isPointer;

  factory TypeRef.void$() = _VoidTypeRef;
  factory TypeRef.bool() = _BoolTypeRef;
  // ignore: avoid_positional_boolean_parameters
  factory TypeRef.int(bool asReturn) = _IntTypeRef;
  factory TypeRef.returnSize() = _ReturnSizeTypeRef;
  factory TypeRef.string() = _StringTypeRef;
  factory TypeRef.dateTime() = _DateTimeTypeRef;
  factory TypeRef.stringList() = _StringListTypeRef;
  factory TypeRef.byteArray() = _ByteArrayTypeRef;
  factory TypeRef.etebaseCollectionAccessLevel() =
      _EtebaseCollectionAccessLevelTypeRef;
  factory TypeRef.etebasePrefetchOption() = _EtebasePrefetchOptionTypeRef;
  factory TypeRef.etebaseClass(String name) = _EtebaseClassTypeRef;
  factory TypeRef.etebaseClassList(String name) = _EtebaseClassListTypeRef;
  factory TypeRef.etebaseOutList(String name) = _EtebaseOutListTypeRef;
}

abstract class _SingleTypeRef implements TypeRef {
  final TypeReference _type;

  _SingleTypeRef(this._type);

  @override
  TypeReference get ffiType => _type;

  @override
  bool get isListType => false;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => false;

  @override
  TypeReference get publicType => _type;

  @override
  TypeReference get transferType => _type;
}

class _VoidTypeRef extends _SingleTypeRef {
  _VoidTypeRef() : super(Types.void$);
}

class _BoolTypeRef extends _SingleTypeRef {
  _BoolTypeRef() : super(Types.bool$);
}

class _IntTypeRef implements TypeRef {
  final bool asReturn;

  // ignore: avoid_positional_boolean_parameters
  _IntTypeRef(this.asReturn);

  @override
  TypeReference get ffiType => Types.int$;

  @override
  bool get isListType => false;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => false;

  @override
  TypeReference get publicType => asReturn ? Types.void$ : Types.int$;

  @override
  TypeReference get transferType => asReturn ? Types.void$ : Types.int$;
}

class _ReturnSizeTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.UnsignedLong$);

  @override
  bool get isListType => false;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => false;

  @override
  TypeReference get publicType => Types.int$;

  @override
  TypeReference get transferType => Types.int$;
}

class _StringTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Char$);

  @override
  bool get isListType => false;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => false;

  @override
  TypeReference get publicType => Types.String$;

  @override
  TypeReference get transferType => Types.String$;
}

class _DateTimeTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Int64$);

  @override
  bool get isListType => false;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => false;

  @override
  TypeReference get publicType => Types.DateTime$;

  @override
  TypeReference get transferType => Types.DateTime$;
}

class _StringListTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Char$);

  @override
  bool get isListType => true;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => false;

  @override
  TypeReference get publicType => Types.list(Types.String$);

  @override
  TypeReference get transferType => Types.list(Types.String$);
}

class _ByteArrayTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Void$);

  @override
  bool get isListType => true;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => false;

  @override
  TypeReference get publicType => Types.Uint8List$;

  @override
  TypeReference get transferType => Types.Uint8List$;
}

class _EtebaseCollectionAccessLevelTypeRef extends _SingleTypeRef {
  _EtebaseCollectionAccessLevelTypeRef()
      : super(Types.EtebaseCollectionAccessLevel$);
}

class _EtebasePrefetchOptionTypeRef extends _SingleTypeRef {
  _EtebasePrefetchOptionTypeRef() : super(Types.EtebasePrefetchOption$);
}

class _EtebaseClassTypeRef implements TypeRef {
  final String name;

  _EtebaseClassTypeRef(this.name);

  @override
  TypeReference get ffiType => Types.pointer(Types.ffi(refer(name)));

  @override
  bool get isListType => false;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => true;

  @override
  TypeReference get publicType => TypeReference((b) => b..symbol = name);

  @override
  TypeReference get transferType => Types.int$;
}

class _EtebaseClassListTypeRef implements TypeRef {
  final String name;

  _EtebaseClassListTypeRef(this.name);

  @override
  TypeReference get ffiType =>
      Types.pointer(Types.pointer(Types.ffi(refer(name))));

  @override
  bool get isListType => true;

  @override
  bool get isOutType => false;

  @override
  bool get isPointer => true;

  @override
  TypeReference get publicType =>
      Types.list(TypeReference((b) => b..symbol = name));

  @override
  TypeReference get transferType => Types.list(Types.int$);
}

class _EtebaseOutListTypeRef implements TypeRef {
  final String name;

  _EtebaseOutListTypeRef(this.name);

  @override
  TypeReference get ffiType =>
      Types.pointer(Types.pointer(Types.ffi(refer(name))));

  @override
  bool get isListType => true;

  @override
  bool get isOutType => true;

  @override
  bool get isPointer => true;

  @override
  TypeReference get publicType =>
      Types.list(TypeReference((b) => b..symbol = name));

  @override
  TypeReference get transferType => Types.list(Types.int$);
}
