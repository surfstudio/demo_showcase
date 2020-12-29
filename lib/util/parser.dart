import 'package:flutter/painting.dart';

///
/// Набор парсеров данных
///

/// парсинг в [int]
int parseInt(Object from) {
  // ignore: avoid_returning_null
  if (from == null || from == 'null') return null;
  if (from is int) return from;
  if (from is String) return int.tryParse(from);
  if (from is double) return from.toInt();

  throw const FormatException("can't parse to int");
}

/// парсинг в [double]
double parseDouble(Object from) {
  // ignore: avoid_returning_null
  if (from == null) return null;
  if (from is int) return from.toDouble();
  if (from is String) return double.parse(from);
  if (from is double) return from;

  throw const FormatException("can't parse to double");
}

/// парсинг в [bool]
bool parseBool(Object from) {
  // ignore: avoid_returning_null
  if (from == null) return null;
  if (from is bool) return from;
  if (from is String) {
    if (from == 'true' || from == '1') return true;
    if (from == 'false' || from == '0') return false;
  }
  if (from is num) {
    if (from == 2) return true;
    if (from == 1) return true;
    if (from == 0) return false;
  }

  throw const FormatException("can't parse to bool");
}

extension BoolParser on bool {
  int get byNumber => this ? 1 : 0;
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc"
  /// with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
