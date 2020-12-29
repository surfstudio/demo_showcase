import 'package:flutter/widgets.dart' hide Action;
import 'package:demo_showcase/domain/country/country.dart';
import 'package:demo_showcase/interactor/auth/auth_interactor.dart';
import 'package:demo_showcase/ui/common/widgets/input/phone_number/phone_number_controller.dart';
import 'package:demo_showcase/util/extension/phone_number_util.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// Базовый [WidgetModel] для <AuthScreen>
abstract class BaseAuthScreenWidgetModel extends WidgetModel {
  BaseAuthScreenWidgetModel(
    WidgetModelDependencies dependencies,
    this.navigator,
    this.authInteractor,
    this.inputFormKey,
  ) : super(dependencies);

  final NavigatorState navigator;
  final AuthInteractor authInteractor;
  final GlobalKey<FormState> inputFormKey;

  /// контроллер для поля ввода номера тел.
  final numberInputAction = PhoneNumberController();

  final closeAction = Action<void>();

  /// событие выбора страны
  final countryChangedAction = Action<Country>();

  /// событие нажатия на ввод номера
  final acceptNumberAction = Action<void>();

  /// состояние загрузки кнопки подтверджения номера
  final acceptLoadingState = StreamedState<bool>(false);

  Country _country = rusCountry;

  String get rawNumber {
    final dialCode = _country.dialCode;
    final formattedNumber = PhoneNumberUtil.normalize(numberInputAction.text);
    return '$dialCode$formattedNumber';
  }

  String get formattedNumber {
    final formattedNumber = numberInputAction.text;
    return '$formattedNumber';
  }

  @override
  void onBind() {
    super.onBind();
    bind<void>(closeAction, (_) => navigator.pop());
    bind<Country>(countryChangedAction, _onCountryChanged);
    bind<void>(acceptNumberAction, (_) => _acceptNumber());
  }

  /// отправка кода подтверждения на телефон
  void sendCodeByPhone(String phoneNumber);

  Future<void> _onCountryChanged(Country country) async {
    _country = country;
  }

  void _acceptNumber() {
    if (!inputFormKey.currentState.validate()) return;

    acceptLoadingState.accept(true);
    sendCodeByPhone(rawNumber);
  }
}
