import 'package:flutter/material.dart' hide Action;
import 'package:flutter/widgets.dart' hide Action;
import 'package:demo_showcase/ui/common/widgets/button/out_button.dart';
import 'package:demo_showcase/ui/common/widgets/input/phone_number/phone_number_text_field.dart';
import 'package:demo_showcase/ui/common/widgets/loading_indicator.dart';
import 'package:demo_showcase/ui/screen/auth/input_number/base_auth_screen_wm.dart';
import 'package:demo_showcase/ui/screen/auth/input_number/di/auth_screen_component.dart';
import 'package:surf_injector/surf_injector.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// Экран авторизации. Содержит 1 шаг - ввод номера телефона
class AuthScreen extends MwwmWidget<AuthScreenComponent> {
  AuthScreen({
    Key key,
  }) : super(
          widgetModelBuilder: (ctx) {
            final component = Injector.of<AuthScreenComponent>(ctx).component;
            return createAuthWM(component);
          },
          dependenciesBuilder: (context) => AuthScreenComponent(context),
          widgetStateBuilder: () => _AuthScreenState(),
          key: key,
        );
}

class _AuthScreenState extends WidgetState<BaseAuthScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Injector.of<AuthScreenComponent>(context).component.scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      actions: [
        IconButton(
          onPressed: wm.closeAction,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 24.0,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 8.0),
          Expanded(
            child: _buildContent(),
          ),
          _buildFooter(),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      children: [
        Text('Для авторизации укажите ваш номер телефона'),
        const SizedBox(height: 20.0),
        Form(
          key: Injector.of<AuthScreenComponent>(context).component.inputFormKey,
          child: _buildPhoneInput(),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return PhoneNumberTextField(
      controller: wm.numberInputAction,
      onCountryChanged: wm.countryChangedAction,
      autoFocus: true,
      hintStyle: TextStyle(fontSize: 20),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        const SizedBox(width: 16.0),
        _AcceptNumberButton(
          acceptNumberAction: wm.acceptNumberAction,
          loadingState: wm.acceptLoadingState,
        ),
      ],
    );
  }
}

class _AcceptNumberButton extends StatelessWidget {
  const _AcceptNumberButton({
    Key key,
    this.acceptNumberAction,
    this.loadingState,
  }) : super(key: key);

  final Action<void> acceptNumberAction;
  final StreamedState<bool> loadingState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.0,
      width: 56.0,
      child: OutButton(
        onPressed: acceptNumberAction,
        padding: EdgeInsets.zero,
        child: Center(
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return StreamedStateBuilder<bool>(
      streamedState: loadingState,
      builder: (ctx, isLoading) {
        return Center(
          child: isLoading ? _buildLoadingState() : _buildArrow(),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 24.0,
      width: 24.0,
      child: LoadingIndicator(
        strokeWidth: 2,
        color: Colors.lightBlueAccent,
      ),
    );
  }

  Widget _buildArrow() {
    return const Icon(
      Icons.arrow_forward,
      color: Colors.lightBlueAccent,
      size: 24.0,
    );
  }
}
