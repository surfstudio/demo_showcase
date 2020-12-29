import 'package:flutter/widgets.dart' hide Action;
import 'package:demo_showcase/domain/library/feedback/feedback.dart';
import 'package:demo_showcase/domain/library/feedback/feedback_local_info.dart';
import 'package:demo_showcase/domain/library/feedback/feedback_type.dart';
import 'package:demo_showcase/interactor/feedback/feedback_interactor.dart';
import 'package:demo_showcase/ui/base/default_dialog_controller.dart';
import 'package:demo_showcase/ui/common/widgets/dialogs/thank_you_dialog.dart';
import 'package:demo_showcase/ui/common/widgets/input/phone_number/phone_number_controller.dart';
import 'package:demo_showcase/ui/screen/feedback/feedback_dialog_owner.dart';
import 'package:demo_showcase/util/regexps.dart';
import 'package:pedantic/pedantic.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// [WidgetModel] для <FeedbackScreen>
class FeedbackScreenWidgetModel extends WidgetModel {
  FeedbackScreenWidgetModel(
    WidgetModelDependencies dependencies,
    this._navigator,
    this._globalNavigator,
    this._dialogController,
    this._feedbackInteractor,
  ) : super(dependencies);

  final NavigatorState _navigator;
  final NavigatorState _globalNavigator;
  final DefaultDialogController _dialogController;
  final FeedbackInteractor _feedbackInteractor;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = PhoneNumberController();
  final messageController = TextEditingController();

  /// Тема сообщения
  final messageThemeState = StreamedState<FeedbackType>(FeedbackType.none);

  final nameErrorState = StreamedState<String>();
  final emailErrorState = StreamedState<String>();
  final phoneErrorState = StreamedState<String>();
  final messageThemeErrorState = StreamedState<String>();
  final messageErrorState = StreamedState<String>();

  /// Состояние загрузки экрана
  final loadingState = StreamedState<bool>(false);

  /// Изменение темы сообщения
  final messageThemeChangedAction = Action<FeedbackType>();

  /// Открыть пользовательское соглашение
  final openAgreementAction = Action<void>();

  /// Отправить сообщение
  final sendFeedback = Action<void>();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final messageFocusNode = FocusNode();

  bool get _isFormValid {
    _validateForm();

    return (nameErrorState.value == null) &&
        (emailErrorState.value == null) &&
        (phoneErrorState.value == null) &&
        (messageThemeErrorState.value == null) &&
        (messageErrorState.value == null);
  }

  String get _name => nameController.text.trim();

  String get _email => emailController.text.trim();

  FeedbackType get _theme => messageThemeState.value;

  String get _message => messageController.text.trim();

  @override
  void onLoad() {
    super.onLoad();

    _initListeners();

    if (_feedbackInteractor.hasLocalData) {
      _setLocalInfo(_feedbackInteractor.getFeedbackLocalInfo());
    }
  }

  @override
  void onBind() {
    super.onBind();

    bind<FeedbackType>(messageThemeChangedAction, _onMessageThemeChanged);
    bind<void>(sendFeedback, (_) => _sendFeedback());
  }

  @override
  void dispose() {
    super.dispose();

    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    messageFocusNode.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
  }

  void _onMessageThemeChanged(FeedbackType type) {
    if (type != null) {
      messageThemeState.accept(type);
    }
    _validateMessageTheme();
  }

  void _initListeners() {
    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) _validateName();
    });
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) _validateEmail();
    });
    phoneFocusNode.addListener(() {
      if (!phoneFocusNode.hasFocus) _validatePhone();
    });
    messageFocusNode.addListener(() {
      if (!messageFocusNode.hasFocus) _validateMessage();
    });
  }

  Future<void> _sendFeedback() async {
    try {
      if (!_isFormValid) return;

      final feedback = Feedback(
        name: _name,
        email: _email,
        phone: phoneController.formattedPhone,
        theme: _theme,
        message: _message,
      );
      unawaited(loadingState.accept(true));

      final isRequestSuccess = await _feedbackInteractor.sendFeedback(feedback);

      unawaited(loadingState.accept(false));
      _saveLocalInfo(feedback);
      if (isRequestSuccess) {
        await _openSuccessDialog();
      }
    } on Exception catch (e) {
      handleError(e);
      unawaited(loadingState.accept(false));
    }
  }

  void _validateForm() {
    _validateName();
    _validateEmail();
    _validatePhone();
    _validateMessageTheme();
    _validateMessage();
  }

  void _validateName() {
    if (_name.isEmpty) {
      nameErrorState.accept('Поле не может быть пустым');
    } else {
      nameErrorState.accept(null);
    }
  }

  void _validateEmail() {
    if (_email.isEmpty) {
      emailErrorState.accept('Укажите адрес электронной почты');
    } else if (!Regexps.email.hasMatch(_email)) {
      emailErrorState.accept('Некорректный формат почты');
    } else {
      emailErrorState.accept(null);
    }
  }

  void _validatePhone() {
    if (!phoneController.isValidLength()) {
      phoneErrorState.accept('Укажите номер телефона');
    } else {
      phoneErrorState.accept(null);
    }
  }

  void _validateMessageTheme() {
    if (messageThemeState.value == FeedbackType.none) {
      messageThemeErrorState.accept('Поле не может быть пустым');
    } else {
      messageThemeErrorState.accept(null);
    }
  }

  void _validateMessage() {
    if (_message.isEmpty) {
      messageErrorState.accept('Поле не может быть пустым');
    } else {
      messageErrorState.accept(null);
    }
  }

  Future<void> _openSuccessDialog() async {
    await _dialogController.showModalSheet<void>(
      FeedbackDialogType.success,
      data: ThankYouDialogData(
        title: 'Сообщение отправлено',
        subtitle: 'Мы рассмотрим ваше сообщение и\nдадим  ответ в течение 1 рабочего дня.\nСпасибо, что помогаете нам стать лучше.',
        buttonText: 'Закрыть',
        onTap: _globalNavigator.pop,
      ),
      isScrollControlled: true,
    );

    _navigator.pop();
  }

  void _saveLocalInfo(Feedback feedback) {
    final info = FeedbackLocalInfo(
      name: feedback.name,
      phone: feedback.phone,
      email: feedback.email,
      country: phoneController.country,
    );

    _feedbackInteractor.setFeedbackLocalInfo(info);
  }

  void _setLocalInfo(FeedbackLocalInfo info) {
    nameController.text = info.name;
    emailController.text = info.email;
    phoneController
      ..text = info.phone
      ..country = info.country;
  }
}
