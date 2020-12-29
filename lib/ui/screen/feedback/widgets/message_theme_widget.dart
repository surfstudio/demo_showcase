import 'package:flutter/material.dart';
import 'package:demo_showcase/domain/library/feedback/feedback_type.dart';
import 'package:demo_showcase/ui/screen/feedback/widgets/message_theme_dialog.dart';
import 'package:demo_showcase/util/string_utils.dart';

/// Виджет для темы сообщения при отправке обратной связи
class MessageThemeWidget extends StatelessWidget {
  const MessageThemeWidget({
    @required this.type,
    @required this.onSelect,
    this.error,
    Key key,
  })  : assert(type != null),
        assert(onSelect != null),
        super(key: key);

  /// Тип сообщения обратной связи
  final FeedbackType type;

  /// Колбэк после выбора типа сообщения
  final ValueSetter<FeedbackType> onSelect;

  /// Текст ошибки
  final String error;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => _onTap(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: error == null ? Colors.grey : Colors.red,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _buildTitle(context)),
                      Padding(
                        padding: _errorPadding,
                        child: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ),
              if (error != null)
                Text(
                  error,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: _errorPadding,
      child: Text(type.title ?? EMPTY_STRING),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    final feedbackType = await showModalBottomSheet<FeedbackType>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => MessageThemeDialog(
        type: type,
      ),
      useRootNavigator: true,
      isScrollControlled: true,
    );
    onSelect?.call(feedbackType);
  }

  EdgeInsets get _errorPadding =>
      EdgeInsets.only(bottom: error != null ? 12 : 0);
}
