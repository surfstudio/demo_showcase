import 'package:flutter/widgets.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/util/extension/phone_number_util.dart';

/// числовая маска без пробелов
const _numberMask = '000000000000000';

/// Текст - контроллер для номера телефона
class PhoneNumberController extends _MaskedTextController {
  PhoneNumberController({
    String text,
    String mask,
    Map<String, RegExp> translator,
  }) : super(
          text: text,
          mask: mask ?? rusCountry.inputMask,
          translator: translator,
        );

  Country get country => _country;

  set country(Country country) {
    _country = country;
    if (mask != country.inputMask) {
      updateMask(country.inputMask ?? _numberMask);
    }
  }

  Country _country = rusCountry;

  String get formattedPhone {
    return '${country.dialCode}${PhoneNumberUtil.normalize(text)}';
  }

  /// проверяю совпадение текста и маски
  bool isValidLength([String textInput]) {
    // обычные маски игнорируем
    if (mask == _numberMask) return true;

    final input = textInput ?? text;
    return input.length == mask.length;
  }
}

class _MaskedTextController extends TextEditingController {
  _MaskedTextController({
    String text,
    this.mask,
    Map<String, RegExp> translator,
  }) : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      updateText(this.text);
    });

    updateText(this.text);
  }

  String mask;

  Map<String, RegExp> translator;

  String _lastUpdatedText = '';

  void updateText(String text) {
    String updatedText;
    if ((text.length - _lastUpdatedText.length).abs() > 1) {
      updatedText = handlePasteAction(text);
    } else {
      updatedText = text;
    }
    if (updatedText != null) {
      this.text = _applyMask(mask, updatedText);
    } else {
      this.text = '';
    }

    _lastUpdatedText = this.text;
  }

  String handlePasteAction(String text) {
    String updatedText = text;
    final textNumbers = text.replaceAll(RegExp('[^0-9]'), '');

    final maskLength = _computeMaskLength(mask);
    if (textNumbers.length > maskLength) {
      updatedText = textNumbers.substring(textNumbers.length - maskLength);
    }

    return updatedText;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final text = _lastUpdatedText;
    selection =
        TextSelection.fromPosition(TextPosition(offset: (text ?? '').length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  String _applyMask(String mask, String value) {
    String result = '';

    var maskCharIndex = 0;
    var valueCharIndex = 0;

    // ignore: literal_only_boolean_expressions
    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final maskChar = mask[maskCharIndex];
      final valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar].hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      // ignore: use_string_buffers
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }

  /// получить кол-во символов в маске
  int _computeMaskLength(String mask) => PhoneNumberUtil.normalize(mask).length;
}
