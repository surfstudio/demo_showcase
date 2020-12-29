import 'package:flutter/material.dart';

/// Виджет, задающий фон для [child]
/// * решает проблему пропадания pressState от кнопок (или InkWell)
class MaterialContainer extends StatelessWidget {
  const MaterialContainer({
    Key key,
    this.color,
    this.child,
    this.decoration,
    this.height,
    this.width,
    this.padding,
  }) : super(key: key);

  final Color color;
  final Widget child;
  final Decoration decoration;
  final EdgeInsets padding;

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
      decoration: decoration,
      padding: padding,
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
