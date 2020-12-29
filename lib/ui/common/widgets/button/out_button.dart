import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:demo_showcase/ui/common/widgets/button/button_fit.dart';
import 'package:demo_showcase/ui/common/widgets/loading_indicator.dart';

/// Outline кнопка в рамках приложения
class OutButton extends StatelessWidget {
  const OutButton({
    Key key,
    this.child,
    this.onPressed,
    this.focusNode,
    this.borderWidth = 1,
    this.buttonFit = ButtonFit.fill,
    this.borderColor = const Color(0xFF33C923),
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 31),
    this.isLoading = false,
  }) : super(key: key);

  final VoidCallback onPressed;
  final FocusNode focusNode;
  final EdgeInsets padding;
  final Color borderColor;
  final double borderWidth;
  final ButtonFit buttonFit;
  final Widget child;
  final BorderRadius borderRadius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return buttonFit == ButtonFit.loose
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildButton(context),
            ],
          )
        : _buildButton(context);
  }

  Widget _buildButton(BuildContext context) {
    return OutlineButton(
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(20.0)),
      ),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
      highlightedBorderColor: borderColor,
      highlightColor: borderColor.withOpacity(0.15),
      splashColor: Colors.transparent,
      padding: padding,
      focusNode: focusNode,
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? _buildLoadingState() : child,
    );
  }

  Widget _buildLoadingState() {
    return const FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        height: 24,
        width: 24,
        child: LoadingIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
