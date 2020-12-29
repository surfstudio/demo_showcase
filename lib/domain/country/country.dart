import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:demo_showcase/util/string_utils.dart';

/// Объект России
final rusCountry = Country.byCode(rusCountryCode);

/// код России
const rusCountryCode = 'RU';

/// код Казахстана
const kazCountryCode = 'KZ';

/// Представление страны
@immutable
class Country {
  const Country({
    @required this.flagUri,
    @required this.code,
    @required this.dialCode,
    this.inputMask = '',
  });

  /// получение страны по ее коду
  /// В тестовой версии всегда Россия
  factory Country.byCode(String code) {
    return Country(
        code: rusCountryCode,
        dialCode: '+7',
        inputMask: '+7 (000) 000 00 00',
    );
  }

  /// путь к ресурсу флага
  final String flagUri;

  /// код страны (IT,AF..)
  final String code;

  /// код номера телефона (+39,+93..)
  final String dialCode;

  /// Маска ввода для поля (optional)
  final String inputMask;
}

/// Локализованное представление страны с названием
class LocalizedCountry extends Country {
  LocalizedCountry({String name, Country parent})
      : name = name ?? EMPTY_STRING,
        super(
          flagUri: parent.flagUri,
          code: parent.code,
          dialCode: parent.dialCode,
          inputMask: parent.inputMask,
        );

  final String name;

  @override
  String toString() => '$name $dialCode';
}