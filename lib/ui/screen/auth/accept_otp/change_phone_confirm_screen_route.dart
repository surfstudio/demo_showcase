import 'package:flutter/material.dart';
import 'package:demo_showcase/domain/auth/auth_otp_info.dart';
import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/ui/screen/auth/accept_otp/accept_otp_screen.dart';

/// Роут для [AcceptOtpScreen] в режиме смены номера
class ChangePhoneConfirmScreenRoute extends MaterialPageRoute<void> {
  /// [phone] - номер телефона, на который отправлен ОТП-код
  ///   * формат - +7 (999) 888 77 66
  /// [otpInfo] - промежуточные данные о текущей авторизации
  ChangePhoneConfirmScreenRoute(
    PhoneNumber phone,
    Country country,
    AuthOtpInfo otpInfo,
  ) : super(
          builder: (ctx) => AcceptOtpScreen(
            phone: phone,
            country: country,
            otpInfo: otpInfo,
          ),
        );
}
