import 'package:flutter/material.dart';

/// Виджет селектор
class SelectWidget extends StatefulWidget {
  const SelectWidget({
    @required this.isSelected,
    Key key,
    this.title,
    this.onSelect,
    this.padding = EdgeInsets.zero,
  })  : assert(isSelected != null),
        super(key: key);

  final String title;

  final bool isSelected;

  final ValueSetter<bool> onSelect;

  final EdgeInsets padding;

  @override
  _SelectWidgetState createState() => _SelectWidgetState();
}

class _SelectWidgetState extends State<SelectWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          if (widget.onSelect != null) {
            widget.onSelect(!widget.isSelected);
          }
        },
        child: Padding(
          padding: widget.padding,
          child: SizedBox(
            height: 48,
            child: Row(
              children: [
                Icon(
                  widget.isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title ?? '',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
