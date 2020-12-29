import 'package:demo_showcase/domain/auth/auth_otp_info.dart';
import 'package:demo_showcase/domain/auth/token_pair.dart';

/// Репозиторий для сервиса авторизации
class AuthRepository {
  /// 1 шаг авторизации
  /// отправка ОТП-кода пользователю
  ///
  /// [phone] - номер телефона пользователя
  Future<AuthOtpInfo> sendOtp(String phone) =>
      Future.delayed(const Duration(seconds: 1)).then(
        (value) => AuthOtpInfo(
          timeToNextOtp: 100000,
          countOfAttempt: 5,
          authToken: '1',
          expiresIn: 1000,
        ),
      );

  /// 2 шаг авторизации
  /// подтверждение ОТП-кода
  ///
  /// [authToken] - промежуточный токен на время подтверждение ОТП-кода
  /// [otpCode] - код из СМС
  Future<TokenPair> acceptOtp(String authToken, String otpCode) =>
      Future.delayed(const Duration(seconds: 1)).then(
        (value) => TokenPair(
          access: TemporaryToken(
            value: '1',
            expiresIn: DateTime(DateTime.now().year + 1),
          ),
          refresh: Token('1'),
        ),
      );

  /// Смена номера телефона. отправка нового номера для проверки по ОТП-коду
  Future<AuthOtpInfo> changePhoneNumber(String phone) async {
    return AuthOtpInfo(
      timeToNextOtp: 100000,
      countOfAttempt: 5,
      authToken: '1',
      expiresIn: 1000,
    );
  }

  /// Подтверждение смены номера телефона
  Future<bool> acceptChangePhoneNumber(String otpCode) => Future.value(true);
}
