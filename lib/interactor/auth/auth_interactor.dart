import 'package:demo_showcase/domain/auth/auth_otp_info.dart';
import 'package:demo_showcase/interactor/auth/repository/auth_repository.dart';
import 'package:demo_showcase/interactor/auth/storage/token_storage.dart';

/// Интерактор для работы с авторизацией
class AuthInteractor {
  AuthInteractor(
    this._authRepository,
    this._userStorage,
  );

  final AuthRepository _authRepository;
  final UserStorage _userStorage;

  /// 1 шаг авторизации
  /// отправка ОТП-кода пользователю
  Future<AuthOtpInfo> sendOtp(String phone) => _authRepository.sendOtp(phone);

  /// 2 шаг (финальный) авторизации
  Future<bool> auth({
    String authToken,
    String otpCode,
    String number,
  }) async {
    final tokens = await _authRepository.acceptOtp(authToken, otpCode);
    await Future.wait([
      _userStorage.savePhoneNumber(number),
      _userStorage.saveTokens(tokens),
    ]);
    return tokens != null;
  }

  /// Смена номера телефона. отправка нового номера для проверки по ОТП-коду
  Future<AuthOtpInfo> changePhoneNumber(String phone) {
    return _authRepository.changePhoneNumber(phone);
  }

  /// Подтверждение смены номера телефона
  Future<bool> acceptChangePhoneNumber(
    String otpCode,
    String formattedPhone,
  ) async {
    final successChanged =
        await _authRepository.acceptChangePhoneNumber(otpCode);
    if (successChanged) {
      await _userStorage.savePhoneNumber(formattedPhone);
    }
    return successChanged;
  }
}
