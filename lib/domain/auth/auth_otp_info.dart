import 'package:flutter/foundation.dart';

/// Данные о промежуточной авторизации
@immutable
class AuthOtpInfo {
  const AuthOtpInfo({
    @required this.timeToNextOtp,
    @required this.countOfAttempt,
    this.authToken,
    this.expiresIn,
    this.isFirstTry = true,
  });

  /// Промежуточный токен,
  /// который дается на время между получением кода и его проверки.
  final String authToken;

  /// Время жизни промежуточного токена (в секундах).
  final int expiresIn;

  ///Время до следующего возможного получения ОТП-кода (в секунднах).
  final int timeToNextOtp;

  /// Кол-во попыток для текущего ОТП-кода.
  final int countOfAttempt;

  /// Первая ли попытка отправить код
  final bool isFirstTry;

  /// Уменьшить кол-во попыток на 1
  AuthOtpInfo decrementAttempt() {
    if (countOfAttempt == 0) {
      return this;
    }
    return copyWith(
      isFirstTry: false,
      countOfAttempt: countOfAttempt - 1,
    );
  }

  AuthOtpInfo copyWith({
    String authToken,
    int expiresIn,
    int timeToNextOtp,
    int countOfAttempt,
    bool isFirstTry,
  }) {
    return AuthOtpInfo(
      authToken: authToken ?? this.authToken,
      expiresIn: expiresIn ?? this.expiresIn,
      isFirstTry: isFirstTry ?? this.isFirstTry,
      timeToNextOtp: timeToNextOtp ?? this.timeToNextOtp,
      countOfAttempt: countOfAttempt ?? this.countOfAttempt,
    );
  }
}

/// Данные о номере телефона
class PhoneNumber {
  PhoneNumber({this.raw, this.formatted});

  /// в формате +79991112233
  final String raw;

  /// в формате +7 (999) 111 22 33
  final String formatted;
}
