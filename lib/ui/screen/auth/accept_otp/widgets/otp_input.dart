import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:demo_showcase/util/const.dart';
import 'package:demo_showcase/util/string_utils.dart';
import 'package:demo_showcase/util/parser.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

/// стандартная длина ОТП-кода
const defaultOtpCodeLength = 5;

const _invisibleOpacity = 0.5;

/// Виджет для ввода ОТП-кода
class OtpFieldWidget extends StatefulWidget {
  const OtpFieldWidget({
    Key key,
    this.initValue,
    this.countOfDigit = defaultOtpCodeLength,
    this.onOtpInput,
    this.hasError = false,
  }) : super(key: key);

  /// кол-во символов в коде
  final int countOfDigit;

  /// предустановленный код (или часть кода)
  final String initValue;

  /// колбэк на ввод кода
  final ValueChanged<String> onOtpInput;

  /// есть ли состояние ошибки
  final bool hasError;

  @override
  _OtpFieldWidgetState createState() => _OtpFieldWidgetState();
}

class _OtpFieldWidgetState extends State<OtpFieldWidget> {
  static const _itemPadding = EdgeInsets.symmetric(horizontal: 4.0);

  TextEditingController _editingController;

  List<int> _digits = [];
  String _prevResult = EMPTY_STRING;

  String get _otpResult => _digits.join();

  int get _focusPosition => _digits.length;

  @override
  void initState() {
    super.initState();
    _editingController = MaskedTextController(
      text: widget.initValue,
      mask: _generateMask(widget.countOfDigit),
    );
    _editingController.addListener(() {
      if (_editingController.text != _prevResult) {
        onInput(_editingController.text);
      }
      _prevResult = _editingController.text;
    });
  }

  @override
  void didUpdateWidget(OtpFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initValue != _otpResult &&
        widget.initValue != oldWidget.initValue) {
      _editingController.text = widget.initValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildInvisibleInput(),
        _buildOtpNumbers(),
      ],
    );
  }

  Widget _buildInvisibleInput() {
    return Opacity(
      opacity: _invisibleOpacity,
      child: TextField(
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        controller: _editingController,
        autofocus: true,
        enableInteractiveSelection: false,
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildOtpNumbers() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.countOfDigit,
          _buildDigitItem,
        ),
      ),
    );
  }

  Widget _buildDigitItem(int index) {
    final itemWidget = _getDigitByIndex(index) == invalidIndex
        ? _buildSpace(index == _focusPosition)
        : Padding(
            padding: _itemPadding,
            child: Text(
              _digits[index].toString(),
              style: TextStyle(fontSize: 32),
            ),
          );

    return SizedBox(
      width: 32.0,
      child: itemWidget,
    );
  }

  Widget _buildSpace(bool inFocus) {
    return Container(
      height: 2.0,
      width: 24.0,
      margin: _itemPadding,
    );
  }

  int _getDigitByIndex(int index) {
    if (index >= _digits.length) return invalidIndex;
    return _digits[index];
  }

  void onInput(String value) {
    setState(() {
      widget.onOtpInput?.call(value);
      _digits = value.split(emptyString).map(parseInt).toList();
    });
  }

  /// сгенерировать маску по кол-ву символом
  /// 3 => '000'
  String _generateMask(int countOfDigit) {
    return List.generate(countOfDigit, (_) => 0).join();
  }
}
