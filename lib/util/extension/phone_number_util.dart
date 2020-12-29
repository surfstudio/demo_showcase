/// Утилиты для номера телефона
class PhoneNumberUtil {
  /// Возвращает только цифры из номера телефона
  /// 9801234567
  /// [number] - номер телефона с перемешанными символами
  static String normalize(String number) {
    final buff = StringBuffer();
    for (var i = 0; i < number.length; i++) {
      final String o = number[i];
      if (int.tryParse(o) != null) {
        buff.write(o);
      }
    }

    return buff.toString();
  }
}
