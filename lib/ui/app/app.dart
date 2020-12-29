import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:surf_injector/surf_injector.dart';
import 'di/app_wm_builder.dart';
import 'di/app_component.dart';
import 'app_wm.dart';

/// Экран
class App extends MwwmWidget<AppComponent> {
  App([
    WidgetModelBuilder widgetModelBuilder = createAppWidgetModel,
  ]) : super(
          widgetModelBuilder: widgetModelBuilder,
          dependenciesBuilder: (context) => AppComponent(context),
          widgetStateBuilder: () => _AppState(),
        );
}

class _AppState extends WidgetState<AppWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: Injector.of<AppComponent>(context).component.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Шаблоны'),
        ),
        body: Container(
          child: Text('Splash'),
        ),
      ),
    );
  }
}
