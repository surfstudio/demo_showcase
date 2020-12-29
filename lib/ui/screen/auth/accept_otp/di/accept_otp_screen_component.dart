import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:demo_showcase/domain/auth/auth_otp_info.dart';
import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/interactor/feedback/feedback_interactor.dart';
import 'package:demo_showcase/ui/app/di/app_component.dart';
import 'package:demo_showcase/ui/base/default_dialog_controller.dart';
import 'package:demo_showcase/ui/base/error/standard_error_handler.dart';
import 'package:demo_showcase/ui/base/material_message_controller.dart';
import 'package:demo_showcase/ui/screen/auth/accept_otp/accept_otp_screen_wm.dart';
import 'package:demo_showcase/ui/screen/auth/accept_otp/base_accept_otp_screen_wm.dart';

import 'package:surf_injector/surf_injector.dart';

/// [Component] для <AcceptOtpScreen>
class AcceptOtpScreenComponent implements Component {
  AcceptOtpScreenComponent(
    BuildContext context,
    this.country,
  ) {
    appComponent = Injector.of<AppComponent>(context).component;

    messageController = MaterialMessageController(scaffoldKey);
    dialogController = DefaultDialogController(scaffoldKey);
    navigator = Navigator.of(context);
    rootNavigator = Navigator.of(context, rootNavigator: true);

    wmDependencies = WidgetModelDependencies(
      errorHandler: StandardErrorHandler(
        messageController,
        dialogController,
      ),
    );
    _feedbackInteractor = appComponent.feedbackInteractor;
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final Country country;

  AppComponent appComponent;
  MessageController messageController;
  DialogController dialogController;
  NavigatorState navigator;
  NavigatorState rootNavigator;
  WidgetModelDependencies wmDependencies;
  FeedbackInteractor _feedbackInteractor;
}

BaseAcceptOtpScreenWidgetModel createAcceptOtpScreenWidgetModel(
  AcceptOtpScreenComponent component,
  PhoneNumber phone,
  AuthOtpInfo otpInfo,
) {
  return AcceptOtpScreenWidgetModel(
    component.wmDependencies,
    component.navigator,
    component.messageController,
    component.appComponent.authInteractor,
    component._feedbackInteractor,
    phone,
    component.country,
    otpInfo,
  );
}
