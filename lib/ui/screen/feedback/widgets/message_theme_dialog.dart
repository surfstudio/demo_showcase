import 'package:flutter/material.dart';
import 'package:demo_showcase/domain/library/feedback/feedback_type.dart';
import 'package:demo_showcase/ui/common/widgets/select_widget.dart';

/// Диалог выбора темы сообщения обратной связи
class MessageThemeDialog extends StatelessWidget {
  const MessageThemeDialog({
    Key key,
    this.type,
  }) : super(key: key);

  final FeedbackType type;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 308,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: _buildBottomSheetTopView(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: _buildTitle(context),
                ),
                Positioned(
                  left: 0,
                  top: 68,
                  right: 0,
                  child: _buildFeedbackTypes(context),
                ),
                Positioned(
                  left: 28,
                  right: 28,
                  bottom: 24,
                  child: SizedBox(
                    height: 48,
                    child: FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Отмена',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Text('Тема обращения'),
    );
  }

  Widget _buildBottomSheetTopView() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        width: 24,
        height: 4,
        color: Color(0xFF2C2C2E),
      ),
    );
  }

  Widget _buildFeedbackTypes(BuildContext context) {
    final children = <Widget>[];

    for (final t in FeedbackType.values) {
      if (t == FeedbackType.none) continue;

      children.add(
        SelectWidget(
          isSelected: type == t,
          title: t.title,
          onSelect: (_) => onSelected(context, t),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      );
    }
    return Column(
      children: children,
    );
  }

  void onSelected(BuildContext context, FeedbackType type) {
    Navigator.of(context).pop(type);
  }
}
