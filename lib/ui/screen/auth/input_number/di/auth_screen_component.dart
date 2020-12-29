import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:demo_showcase/ui/app/di/app_component.dart';
import 'package:demo_showcase/ui/base/default_dialog_controller.dart';
import 'package:demo_showcase/ui/base/error/standard_error_handler.dart';
import 'package:demo_showcase/ui/base/material_message_controller.dart';
import 'package:demo_showcase/ui/screen/auth/input_number/auth_screen_wm.dart';
import 'package:demo_showcase/ui/screen/auth/input_number/base_auth_screen_wm.dart';
import 'package:surf_injector/surf_injector.dart';

/// [Component] для <AuthScreen>
class AuthScreenComponent implements Component {
  AuthScreenComponent(BuildContext context) {
    parent = Injector.of<AppComponent>(context).component;

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
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final inputFormKey = GlobalKey<FormState>();

  AppComponent parent;
  MessageController messageController;
  DialogController dialogController;
  NavigatorState navigator;
  NavigatorState rootNavigator;

  WidgetModelDependencies wmDependencies;
}

BaseAuthScreenWidgetModel createAuthWM(AuthScreenComponent component) {
  return AuthScreenWidgetModel(
    component.wmDependencies,
    component.navigator,
    component.parent.authInteractor,
    component.inputFormKey,
  );
}
