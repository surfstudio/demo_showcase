import 'package:flutter/material.dart';

/// Индикатор загрузки
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
    this.strokeWidth = 4,
    this.color = Colors.white,
  }) : super(key: key);

  final double strokeWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
      strokeWidth: strokeWidth,
    );
  }
}
