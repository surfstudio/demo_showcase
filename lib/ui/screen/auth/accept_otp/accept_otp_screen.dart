import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:demo_showcase/domain/auth/auth_otp_info.dart';
import 'package:demo_showcase/domain/common/time.dart';
import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/ui/common/widgets/timer_widget.dart';
import 'package:demo_showcase/ui/screen/auth/accept_otp/base_accept_otp_screen_wm.dart';
import 'package:demo_showcase/ui/screen/auth/accept_otp/di/accept_otp_screen_component.dart';
import 'package:demo_showcase/ui/screen/auth/accept_otp/widgets/otp_input.dart';
import 'package:demo_showcase/util/string_utils.dart';
import 'package:demo_showcase/util/time_formatter.dart';
import 'package:surf_injector/surf_injector.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// 2 Шаг авторизации
/// * подтверждение ОТП-кода
class AcceptOtpScreen extends MwwmWidget<AcceptOtpScreenComponent> {
  AcceptOtpScreen({
    Key key,
    PhoneNumber phone,
    Country country,
    AuthOtpInfo otpInfo,
  }) : super(
          widgetModelBuilder: (ctx) {
            final component =
                Injector.of<AcceptOtpScreenComponent>(ctx).component;
            return createAcceptOtpScreenWidgetModel(
              component,
              phone,
              otpInfo,
            );
          },
          dependenciesBuilder: (context) => AcceptOtpScreenComponent(
            context,
            country,
          ),
          widgetStateBuilder: () => _AcceptOtpScreenState(),
          key: key,
        );
}

class _AcceptOtpScreenState
    extends WidgetState<BaseAcceptOtpScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Injector.of<AcceptOtpScreenComponent>(context).component.scaffoldKey,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: _buildOtpPart(),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildOtpPart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EntityStateBuilder<String>(
          streamedState: wm.otpInputState,
          loadingChild: _buildOtpLoader(),
          child: (ctx, otpCode) {
            return OtpFieldWidget(
              initValue: otpCode,
              onOtpInput: wm.otpInputAction,
            );
          },
          errorChild: OtpFieldWidget(
            initValue: EMPTY_STRING,
            onOtpInput: wm.otpInputAction,
            hasError: true,
          ),
        ),
        const SizedBox(height: 10.5),
        StreamedStateBuilder<AuthOtpInfo>(
          streamedState: wm.otpInfoState,
          builder: (ctx, otpInfo) {
            final countOfAttempt = otpInfo.countOfAttempt;
            return otpInfo.isFirstTry
                ? _buildCountOfAttemptText('')
                : _buildCountOfAttemptText(
                    countOfAttempt == 0
                        ? 'У вас не осталось попыток'
                        : 'Осталось попыток: $countOfAttempt',
                  );
          },
        ),
      ],
    );
  }

  Widget _buildCountOfAttemptText(String text) {
    return Text(text);
  }

  Widget _buildOtpLoader() {
    return Stack(
      children: [
        const Opacity(
          opacity: 0.0,
          child: OtpFieldWidget(),
        ),
        Center(child: _buildLoader()),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: StreamedStateBuilder<AuthOtpInfo>(
        streamedState: wm.otpInfoState,
        builder: (ctx, otpInfo) {
          return StreamedStateBuilder<OtpFooterState>(
            streamedState: wm.retryState,
            builder: (ctx, footerState) {
              switch (footerState) {
                case OtpFooterState.waitTimer:
                  return _buildTimerBlock(otpInfo);
                case OtpFooterState.sendLoadState:
                  return _buildLoader();
                case OtpFooterState.canRetryOtp:
                default:
                  return _buildRetryBlock(otpInfo);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildTimerBlock(AuthOtpInfo otpInfo) {
    return Column(
      children: [
        Text(
          'Код отправлен на ${wm.phone.formatted}',
        ),
        const SizedBox(height: 6.0),
        TimerWidget(
          key: Key('TimerWidget-${otpInfo.authToken}'),
          startDuration: Duration(seconds: otpInfo.timeToNextOtp),
          interval: const Duration(seconds: 1),
          onFinished: wm.onTimerFinishedAction,
          builder: (ctx, currentDuration) {
            final timeDuration = TimeDuration(currentDuration);
            return Text(
              TimeFormatter.formatInMinutes(timeDuration),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRetryBlock(AuthOtpInfo otpInfo) {
    return Column(
      children: [
        SizedBox(
          height: 18.0,
          child: MaterialButton(
            onPressed: wm.onRetryClickAction,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text('Отправить код еще раз'),
          ),
        ),
        const SizedBox(height: 6.0),
        Text(
          'на номер ${wm.phone.formatted}',
        ),
      ],
    );
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 9.0),
      child: SizedBox(
        height: 24.0,
        width: 24.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.6,
        ),
      ),
    );
  }
}
