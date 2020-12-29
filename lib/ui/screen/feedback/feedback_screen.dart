import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:demo_showcase/domain/library/feedback/feedback_type.dart';
import 'package:demo_showcase/ui/common/widgets/button/out_button.dart';
import 'package:demo_showcase/ui/common/widgets/input/phone_number/phone_number_text_field.dart';
import 'package:demo_showcase/ui/screen/feedback/di/feedback_screen_component.dart';
import 'package:demo_showcase/ui/screen/feedback/feedback_screen_wm.dart';
import 'package:demo_showcase/ui/screen/feedback/widgets/message_theme_widget.dart';
import 'package:demo_showcase/util/regexps.dart';
import 'package:surf_injector/surf_injector.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// Экран Обратной связи
class FeedbackScreen extends MwwmWidget<FeedbackScreenComponent> {
  FeedbackScreen({Key key})
      : super(
          widgetModelBuilder: (ctx) {
            final component =
                Injector.of<FeedbackScreenComponent>(ctx).component;
            return createFeedbackScreenWidgetModel(component);
          },
          dependenciesBuilder: (context) => FeedbackScreenComponent(context),
          widgetStateBuilder: () => _FeedbackScreenState(),
          key: key,
        );
}

class _FeedbackScreenState extends WidgetState<FeedbackScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Injector.of<FeedbackScreenComponent>(context).component.scaffoldKey,
      appBar: AppBar(
        title: Text('Обратная связь'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        _buildDescriptionTitle(),
        _buildName(),
        _buildEmail(),
        _buildPhoneNumber(),
        _buildTheme(),
        _buildMessage(),
        _buildSendButton(),
      ],
    );
  }

  Widget _buildDescriptionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Text(
        'Мы ценим Ваше мнение и работаем, чтобы сделать приложение лучше и удобнее. Заполните форму ниже: мы рассмотрим сообщение и дадим ответ в течение 1 рабочего дня.',
      ),
    );
  }

  Widget _buildName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: StreamedStateBuilder<String>(
        streamedState: wm.nameErrorState,
        builder: (context, error) => TextField(
          controller: wm.nameController,
          focusNode: wm.nameFocusNode,
          inputFormatters: [
            FilteringTextInputFormatter.allow(Regexps.lettersAndSpace),
          ],
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          maxLength: 50,
          decoration: _buildTextFieldDecoration('Ваше имя', error),
        ),
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: StreamedStateBuilder<String>(
        streamedState: wm.emailErrorState,
        builder: (context, error) => TextField(
          controller: wm.emailController,
          focusNode: wm.emailFocusNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          decoration: _buildTextFieldDecoration(
            'Электронная почта',
            error,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: StreamedStateBuilder<String>(
        streamedState: wm.phoneErrorState,
        builder: (context, error) => PhoneNumberTextField(
          controller: wm.phoneController,
          textInputAction: TextInputAction.done,
          focusNode: wm.phoneFocusNode,
          error: error,
          errorStyle: TextStyle(
            fontSize: 14,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _buildTheme() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: StreamedStateBuilder<FeedbackType>(
        streamedState: wm.messageThemeState,
        builder: (context, type) => StreamedStateBuilder<String>(
          streamedState: wm.messageThemeErrorState,
          builder: (context, error) => MessageThemeWidget(
            onSelect: wm.messageThemeChangedAction,
            type: type,
            error: error,
          ),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        child: Center(
          child: StreamedStateBuilder<String>(
            streamedState: wm.messageErrorState,
            builder: (context, error) => TextField(
              controller: wm.messageController,
              focusNode: wm.messageFocusNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              decoration: _buildTextFieldDecoration(
                'Ваше сообщение',
                error,
              ),
              maxLines: null,
              maxLength: 4000,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 84),
      child: SizedBox(
        height: 48,
        child: StreamedStateBuilder<bool>(
          streamedState: wm.loadingState,
          builder: (context, isLoading) => OutButton(
            onPressed: wm.sendFeedback,
            isLoading: isLoading,
            child: Text('Отправить'),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildTextFieldDecoration(String hint, String errorText) {
    return InputDecoration(
      errorText: errorText,
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      hintText: hint,
      counterText: '',
      errorStyle: TextStyle(
        fontSize: 14,
        color: Colors.red,
      ),
    );
  }
}
