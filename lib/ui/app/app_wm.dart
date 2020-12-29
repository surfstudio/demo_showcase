import 'package:flutter/material.dart' hide Action;
import 'package:demo_showcase/ui/screen/auth/input_number/auth_screen_route.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// [WidgetModel] для [App]
class AppWidgetModel extends WidgetModel {
  final GlobalKey<NavigatorState> _navigatorState;

  AppWidgetModel(
    WidgetModelDependencies dependencies,
    this._navigatorState,
  ) : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    Future.delayed(const Duration(seconds: 1)).then(
      (_) => _navigatorState.currentState.pushReplacement(
        AuthScreenRoute(),
      ),
    );
  }

  @override
  void onBind() {
    super.onBind();
  }
}
