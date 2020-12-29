import 'dart:async';

import 'package:flutter/widgets.dart';

/// Виджет, который умеет перерисовываться через интервал (таймер)
class TimerWidget extends StatefulWidget {
  const TimerWidget({
    @required this.builder,
    Key key,
    this.startDuration,
    this.interval,
    this.onFinished,
  })  : assert(builder != null),
        super(key: key);

  /// время на таймер
  final Duration startDuration;

  /// интервал перерисовки
  final Duration interval;

  /// билдер на каждый тик таймера
  final Widget Function(BuildContext, Duration) builder;

  /// колбэк на завершение таймера
  final VoidCallback onFinished;

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer _timer;
  Duration _currentDuration;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _currentDuration);
  }

  @override
  void dispose() {
    cancelAutoReload();
    super.dispose();
  }

  void _init() {
    _currentDuration = widget.startDuration;
    _startTimer();
  }

  void _startTimer() {
    cancelAutoReload();
    _timer = Timer.periodic(
      widget.interval,
      (_) => _rebuildNewDuration(),
    );
  }

  void _rebuildNewDuration() {
    if (_currentDuration <= Duration.zero) {
      widget.onFinished?.call();
      cancelAutoReload();
      return;
    }
    setState(() {
      _currentDuration -= widget.interval;
    });
  }

  void cancelAutoReload() {
    _timer?.cancel();
    _timer = null;
  }
}
