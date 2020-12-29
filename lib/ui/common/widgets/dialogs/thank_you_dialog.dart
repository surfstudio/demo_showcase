import 'package:flutter/material.dart';
import 'package:demo_showcase/util/string_utils.dart';
import 'package:demo_showcase/util/ui_const.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

///  Данные для ThankYouDialog
class ThankYouDialogData extends DialogData {
  ThankYouDialogData({
    this.icon,
    this.title,
    this.subtitle,
    this.buttonText,
    this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onTap;
}

/// Стандартный ThankYou-диалог
class ThankYouDialog extends StatelessWidget {
  const ThankYouDialog({
    @required this.data,
    Key key,
  })  : assert(data != null),
        super(key: key);

  final ThankYouDialogData data;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 24,
                  height: 4,
                  color: Color(0xFF2C2C2E),
                ),
                const SizedBox(height: 16),
                Text(data.title ?? EMPTY_STRING),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(data.subtitle ?? EMPTY_STRING),
                ),
                const SizedBox(height: 30),
                Container(
                  height: 48,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: FlatButton(
                    onPressed: data.onTap,
                    child: Text(data.buttonText),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
