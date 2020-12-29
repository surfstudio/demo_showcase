import 'package:flutter/widgets.dart' hide Action;
import 'package:demo_showcase/domain/auth/auth_otp_info.dart';
import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/interactor/auth/auth_interactor.dart';
import 'package:demo_showcase/interactor/feedback/feedback_interactor.dart';
import 'package:demo_showcase/ui/screen/auth/accept_otp/base_accept_otp_screen_wm.dart';
import 'package:demo_showcase/ui/screen/feedback/feedback_screen_route.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:surf_util/surf_util.dart';

/// [WidgetModel] для <AcceptOtpScreen>
class AcceptOtpScreenWidgetModel extends BaseAcceptOtpScreenWidgetModel {
  AcceptOtpScreenWidgetModel(
    WidgetModelDependencies dependencies,
    NavigatorState navigator,
    MessageController messageController,
    AuthInteractor authInteractor,
    FeedbackInteractor feedbackInteractor,
    PhoneNumber phone,
    Country country,
    AuthOtpInfo otpInfo,
  ) : super(
          dependencies,
          navigator,
          messageController,
          authInteractor,
          feedbackInteractor,
          phone,
          country,
          otpInfo,
        );

  /// Отправка нового кода подтверждения
  @override
  void sendNewOtp() {
    retryState.accept(OtpFooterState.sendLoadState);
    doFutureHandleError<AuthOtpInfo>(
      authInteractor.sendOtp(phone.raw),
      (otpInfo) {
        retryState.accept(OtpFooterState.waitTimer);
        otpInfoState.accept(otpInfo);
        otpInputState.content(emptyString);
        showSendNewOTPMessage();
      },
      onError: (Object _) {
        retryState.accept(OtpFooterState.canRetryOtp);
      },
    );
  }

  /// Проверка кода подтверждения
  @override
  void acceptOtpCode(String otpCode) {
    otpInputState.loading();
    doFutureHandleError<bool>(
      authInteractor.auth(
        authToken: otpInfoState.value.authToken,
        otpCode: otpCode,
        number: phone.formatted,
      ),
      (isAuthSuccess) {
        if (isAuthSuccess) {
          feedbackInteractor.savePhone(phone.raw, country);
          navigator.pushReplacement(
            FeedbackScreenRoute(),
          );
        }
      },
      onError: (Object e) {
        otpInputState.error(e);
      },
    );
  }
}
