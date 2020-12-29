import 'package:flutter/material.dart';
import 'package:demo_showcase/interactor/auth/auth_interactor.dart';
import 'package:demo_showcase/interactor/auth/repository/auth_repository.dart';
import 'package:demo_showcase/interactor/auth/storage/token_storage.dart';
import 'package:demo_showcase/interactor/feedback/feedback_interactor.dart';
import 'package:demo_showcase/interactor/feedback/feedback_storage.dart';
import 'package:demo_showcase/interactor/feedback/repository/feedback_repository.dart';
import 'package:demo_showcase/ui/base/default_dialog_controller.dart';
import 'package:demo_showcase/ui/base/material_message_controller.dart';
import 'package:surf_injector/surf_injector.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:get_storage/get_storage.dart';

/// [Component] для [App]
class AppComponent extends Component {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  MessageController messageController;
  DialogController dialogController;
  NavigatorState navigator;

  final getStorage = GetStorage();
  final userStorage = UserStorage();

  AuthInteractor authInteractor;
  FeedbackInteractor feedbackInteractor;

  AppComponent(BuildContext context) {
    messageController = MaterialMessageController(scaffoldKey);
    dialogController = DefaultDialogController(scaffoldKey);
    authInteractor = AuthInteractor(AuthRepository(), userStorage);
    feedbackInteractor = FeedbackInteractor(
      FeedbackStorage(getStorage),
      FeedbackRepository(),
    );
  }
}
