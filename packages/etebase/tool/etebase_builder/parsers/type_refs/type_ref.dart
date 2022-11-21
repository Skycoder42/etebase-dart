import 'package:code_builder/code_builder.dart';

import '../../util/types.dart';

abstract class TypeRef {
  TypeReference get publicType;
  TypeReference get transferType;
  TypeReference get ffiType;

  factory TypeRef.void$() = VoidTypeRef;
  factory TypeRef.bool() = BoolTypeRef;
  factory TypeRef.int() = IntTypeRef;
  factory TypeRef.string() = StringTypeRef;
  factory TypeRef.dateTime() = DateTimeTypeRef;
  factory TypeRef.stringList() = StringListTypeRef;
  factory TypeRef.byteArray() = ByteArrayTypeRef;
  factory TypeRef.etebaseClass(String name) = EtebaseClassTypeRef;
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
  @override
  TypeReference get ffiType => Types.int$;

  @override
  TypeReference get publicType => Types.void$;

  @override
  TypeReference get transferType => Types.void$;
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
  TypeReference get ffiType => Types.pointer(Types.Char$);

  @override
  TypeReference get publicType => Types.list(Types.String$);

  @override
  TypeReference get transferType => Types.list(Types.String$);
}

class ByteArrayTypeRef implements TypeRef {
  @override
  TypeReference get ffiType => Types.pointer(Types.Void$);

  @override
  TypeReference get publicType => Types.Uint8List$;

  @override
  TypeReference get transferType => Types.Uint8List$;
}

class EtebaseClassTypeRef implements TypeRef {
  final String name;

  EtebaseClassTypeRef(this.name);

  @override
  TypeReference get ffiType => Types.pointer(Types.ffi(refer(name)));

  @override
  TypeReference get publicType => TypeReference((b) => b..symbol = name);

  @override
  TypeReference get transferType => Types.int$;
}

class EtebaseOutListTypeRef implements TypeRef {
  final String name;

  EtebaseOutListTypeRef(this.name);

  @override
  TypeReference get ffiType =>
      Types.pointer(Types.pointer(Types.ffi(refer(name))));

  @override
  TypeReference get publicType =>
      Types.list(TypeReference((b) => b..symbol = name));

  @override
  TypeReference get transferType => Types.list(Types.int$);
}
