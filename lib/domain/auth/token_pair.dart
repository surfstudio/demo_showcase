import 'package:flutter/foundation.dart';

/// Пара токенов access-refresh
@immutable
class TokenPair {
  const TokenPair({this.access, this.refresh});

  /// Access-token для доступа к ресурсам сервера
  /// для авторизованного пользователя
  final TemporaryToken access;

  /// Refresh-token для обновление access-токена
  final Token refresh;
}

/// Объект для токена доступа
class Token {
  const Token(this.value);

  final String value;
}

/// Токен-доступа с ограниченным временем жизни
class TemporaryToken implements Token {
  const TemporaryToken({this.value, this.expiresIn});

  /// Токен-доступа из строковых ресурсов
  factory TemporaryToken.fromStrings({String value, String dateIsoFormat}) {
    return TemporaryToken(
      value: value,
      expiresIn: DateTime.tryParse(dateIsoFormat),
    );
  }

  factory TemporaryToken.fromNow({String value, int expiresInSec}) {
    return TemporaryToken(
      value: value,
      expiresIn: DateTime.now().add(Duration(seconds: expiresInSec)),
    );
  }

  /// значение токена
  @override
  final String value;

  /// до какого времени живет токен
  final DateTime expiresIn;

  /// токен не пустой
  bool get isNotEmpty => value.isNotEmpty && expiresIn != null;

  /// не истек ли срок годности токена
  bool get isValid => expiresIn?.isAfter(DateTime.now()) ?? true;
}
