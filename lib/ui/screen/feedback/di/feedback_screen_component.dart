import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:demo_showcase/interactor/feedback/feedback_interactor.dart';
import 'package:demo_showcase/ui/app/di/app_component.dart';
import 'package:demo_showcase/ui/base/default_dialog_controller.dart';
import 'package:demo_showcase/ui/base/error/standard_error_handler.dart';
import 'package:demo_showcase/ui/base/material_message_controller.dart';
import 'package:demo_showcase/ui/screen/feedback/feedback_dialog_owner.dart';
import 'package:demo_showcase/ui/screen/feedback/feedback_screen_wm.dart';
import 'package:surf_injector/surf_injector.dart';

/// [Component] для <FeedbackScreen>
class FeedbackScreenComponent implements Component {
  FeedbackScreenComponent(BuildContext context) {
    final appComponent = Injector.of<AppComponent>(context).component;
    _messageController = MaterialMessageController(scaffoldKey);
    _dialogController = DefaultDialogController(
      scaffoldKey,
      dialogOwner: FeedbackDialogOwner(),
    );
    _navigator = Navigator.of(context);
    _globalNavigator = Navigator.of(context, rootNavigator: true);

    _wmDependencies = WidgetModelDependencies(
      errorHandler: StandardErrorHandler(
        _messageController,
      ),
    );
    _feedbackInteractor = appComponent.feedbackInteractor;
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  MessageController _messageController;
  DefaultDialogController _dialogController;
  NavigatorState _navigator;
  NavigatorState _globalNavigator;
  WidgetModelDependencies _wmDependencies;
  FeedbackInteractor _feedbackInteractor;
}

FeedbackScreenWidgetModel createFeedbackScreenWidgetModel(
  FeedbackScreenComponent component,
) {
  return FeedbackScreenWidgetModel(
    component._wmDependencies,
    component._navigator,
    component._globalNavigator,
    component._dialogController,
    component._feedbackInteractor,
  );
}
