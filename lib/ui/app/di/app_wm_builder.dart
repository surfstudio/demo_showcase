import 'package:flutter/widgets.dart';
import 'package:demo_showcase/ui/base/error/standard_error_handler.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:surf_injector/surf_injector.dart';
import '../app_wm.dart';
import 'app_component.dart';

/// Билдер для [AppWidgetModel]
AppWidgetModel createAppWidgetModel(BuildContext context) {
  var component = Injector.of<AppComponent>(context).component;

  final dependencies = WidgetModelDependencies(
    errorHandler: StandardErrorHandler(
      component.messageController,
      component.dialogController,
    ),
  );

  return AppWidgetModel(dependencies, component.navigatorKey);
}
