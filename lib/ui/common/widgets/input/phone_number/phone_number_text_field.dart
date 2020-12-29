import 'package:flutter/material.dart';
import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/ui/common/widgets/input/phone_number/phone_number_controller.dart';

/// Поле ввода телефонного номера
class PhoneNumberTextField extends StatefulWidget {
  const PhoneNumberTextField({
    @required this.controller,
    @required this.hintStyle,
    this.onCountryChanged,
    this.autoFocus = false,
    this.textInputAction,
    this.focusNode,
    this.error,
    this.errorStyle,
    Key key,
  })  : assert(controller != null),
        super(key: key);

  final PhoneNumberController controller;

  final ValueSetter<Country> onCountryChanged;
  final bool autoFocus;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final String error;

  final TextStyle hintStyle;
  final TextStyle errorStyle;

  @override
  _PhoneNumberTextFieldState createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      autofocus: widget.autoFocus,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumber],
      validator: _getPhoneValidator(),
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        errorText: widget.error,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText: 'Номер телефона',
        hintStyle: widget.hintStyle,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        errorStyle: widget.errorStyle,
      ),
    );
  }

  FormFieldValidator<String> _getPhoneValidator() {
    return (input) {
      return widget.controller.isValidLength(input)
          ? null
          : 'Укажите номер телефона';
    };
  }
}
