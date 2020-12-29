import 'package:flutter/foundation.dart';
import 'package:mwwm/mwwm.dart';
import 'package:demo_showcase/interactor/common/exceptions.dart';
import 'package:demo_showcase/ui/base/error/network_error_handler.dart';
import 'package:demo_showcase/ui/base/material_message_controller.dart';
import 'package:surf_network/surf_network.dart';

/// Стандартная реализация ErrorHandler
class StandardErrorHandler extends NetworkErrorHandler {
  StandardErrorHandler(
    this.messageController, [
    this.dialogController,
    this.showRawDescription = false,
  ]);

  @protected
  final MessageController messageController;

  @protected
  final DialogController dialogController;

  /// флаг по которому игнорируется приведение ошибки к тексту
  /// выводится toString()
  final bool showRawDescription;

  @override
  void handleError(Object e) {
    if (showRawDescription) {
      _show(e.toString());
      return;
    }
    super.handleError(e);
  }

  @override
  void handleOtherError(Exception e) {
    if (e is MessagedException) {
      _show(e.message);
    } else {
      _show(e.toString());
    }
  }

  @override
  void handleHttpProtocolException(HttpProtocolException e) {}

  @override
  void handleConversionError(ConversionException e) {}

  @override
  void handleNoInternetError(NoInternetException e) {}

  void _show(String msg) => messageController.show(
        msg: msg,
        msgType: MsgType.commonError,
      );
}
