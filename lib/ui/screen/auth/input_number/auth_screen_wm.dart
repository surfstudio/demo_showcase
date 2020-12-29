import 'package:flutter/widgets.dart' hide Action;
import 'package:demo_showcase/domain/auth/auth_otp_info.dart';
import 'package:demo_showcase/interactor/auth/auth_interactor.dart';
import 'package:demo_showcase/ui/screen/auth/accept_otp/accept_otp_screen_route.dart';
import 'package:demo_showcase/ui/screen/auth/input_number/base_auth_screen_wm.dart';
import 'package:pedantic/pedantic.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// [WidgetModel] для <AuthScreen> в режиме авторизации
class AuthScreenWidgetModel extends BaseAuthScreenWidgetModel {
  AuthScreenWidgetModel(
    WidgetModelDependencies dependencies,
    NavigatorState navigator,
    AuthInteractor authInteractor,
    GlobalKey<FormState> inputFormKey,
  ) : super(
          dependencies,
          navigator,
          authInteractor,
          inputFormKey,
        );

  /// отправка кода подтверждения на телефон
  @override
  void sendCodeByPhone(String phoneNumber) {
    doFutureHandleError<AuthOtpInfo>(
      authInteractor.sendOtp(phoneNumber),
      (otpInfo) async {
        unawaited(acceptLoadingState.accept(false));
        final isSuccess = await navigator.push<bool>(
          AcceptOtpScreenRoute(
            PhoneNumber(raw: rawNumber, formatted: formattedNumber),
            numberInputAction.country,
            otpInfo,
          ),
        );
        if (isSuccess != null) navigator.pop(isSuccess);
      },
      //ignore: avoid_types_on_closure_parameters
      onError: (Object _) {
        acceptLoadingState.accept(false);
      },
    );
  }
}
