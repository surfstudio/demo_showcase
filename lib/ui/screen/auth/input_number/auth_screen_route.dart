import 'package:flutter/material.dart';
import 'package:demo_showcase/ui/screen/auth/input_number/auth_screen.dart';

/// Роут для [AuthScreen]
class AuthScreenRoute extends MaterialPageRoute<bool> {
  AuthScreenRoute()
      : super(
          builder: (ctx) => AuthScreen(),
          fullscreenDialog: true,
        );
}
