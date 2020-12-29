import 'package:flutter/widgets.dart' hide Action;
import 'package:demo_showcase/domain/auth/auth_otp_info.dart';
import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/interactor/auth/auth_interactor.dart';
import 'package:demo_showcase/interactor/feedback/feedback_interactor.dart';
import 'package:demo_showcase/ui/screen/auth/accept_otp/widgets/otp_input.dart';
import 'package:demo_showcase/util/string_utils.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// Базовый [WidgetModel] для <AcceptOtpScreen>
abstract class BaseAcceptOtpScreenWidgetModel extends WidgetModel {
  BaseAcceptOtpScreenWidgetModel(
    WidgetModelDependencies dependencies,
    this.navigator,
    this.messageController,
    this.authInteractor,
    this.feedbackInteractor,
    this.phone,
    this.country,
    AuthOtpInfo otpInfo,
  )   : otpInfoState = StreamedState(otpInfo),
        retryState = StreamedState(_stateByTimer(otpInfo.expiresIn)),
        super(dependencies);

  /// данные пришедшие извне
  final PhoneNumber phone;
  final Country country;

  /// внешние зависимости
  @protected
  final NavigatorState navigator;
  @protected
  final AuthInteractor authInteractor;
  @protected
  final MessageController messageController;
  @protected
  final FeedbackInteractor feedbackInteractor;

  /// полностью закрыть авторизацию
  final onCloseAuthAction = Action<void>();

  /// таймер до след. кода истек
  final onTimerFinishedAction = Action<void>();

  /// нажатие на "отправить код еще"
  final onRetryClickAction = Action<void>();

  /// событие ввода ОТП-кода
  final otpInputAction = Action<String>();

  /// состояние ввода ОТП-кода
  final otpInputState = EntityStreamedState<String>(
    EntityState.content(EMPTY_STRING),
  );

  /// промежуточное состояние о авторизации до завершения
  final StreamedState<AuthOtpInfo> otpInfoState;

  /// можно ли перезапросить код
  final StreamedState<OtpFooterState> retryState;

  /// состояние загрузки перезапуска ОТП-кода
  final retryLoadState = StreamedState<bool>(false);

  @override
  void onBind() {
    super.onBind();
    bind<void>(onCloseAuthAction, (_) => closeAuth());
    bind<void>(onRetryClickAction, (_) => sendNewOtp());
    bind<String>(otpInputAction, _onOtpInput);
    bind<AuthOtpInfo>(otpInfoState, _otpChanged);
    bind<void>(
      onTimerFinishedAction,
      (_) => retryState.accept(_stateByTimer(0)),
    );
  }

  void _otpChanged(AuthOtpInfo otpInfo) {
    if (retryState.value != OtpFooterState.canRetryOtp) {
      retryState.accept(_stateByTimer(otpInfo.expiresIn));
    }
  }

  void _onOtpInput(String otpCode) {
    if (otpCode.length == defaultOtpCodeLength) {
      acceptOtpCode(otpCode);
      return;
    }
    otpInputState.content(otpCode);
  }

  /// закрытие окна авторизации
  @protected
  void closeAuth() {
    navigator.popUntil((route) => route.isFirst);
  }

  /// Отправка нового кода подтверждения на телефон
  void sendNewOtp();

  /// Проверка кода подтверждения
  void acceptOtpCode(String otpCode);

  /// Уменьшения количества попыток
  @protected
  Future<void> decrementAttempt() async {
    await otpInfoState.accept(otpInfoState.value.decrementAttempt());
  }

  /// Показ сообщения об отправке нового кода подтверждения
  @protected
  void showSendNewOTPMessage() {
    /// TODO вывод сообщения об отправке кода
  }

  static OtpFooterState _stateByTimer(int seconds) {
    return seconds == 0 ? OtpFooterState.canRetryOtp : OtpFooterState.waitTimer;
  }
}

/// состояние футера на экране <AcceptOtpScreen>
enum OtpFooterState {
  /// можно перезапросить отп
  canRetryOtp,

  /// ожидается время до след перезапроса
  waitTimer,

  /// состояние загрузки отправки
  sendLoadState,
}
