import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_util/surf_util.dart';

/// Эмуляция MaterialMessageController приложения
class MaterialMessageController extends MessageController {
  final GlobalKey<ScaffoldState> _scaffoldState;
  final BuildContext _context;
  final snackOwner;

  MaterialMessageController(this._scaffoldState, {this.snackOwner})
      : _context = null;

  MaterialMessageController.from(this._context, {this.snackOwner})
      : _scaffoldState = null;

  ScaffoldState get _state {
    return _scaffoldState?.currentState ?? Scaffold.of(_context, nullOk: true);
  }

  /// Дефолтные снеки, используются если виджет не определил свои
  final Map<dynamic, SnackBar Function(String text)> defaultSnackBarBuilder = {
    MsgType.commonError: (text) => SnackBar(
          content: Text(text),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
    MsgType.common: (text) => SnackBar(
          content: Text(text),
          duration: const Duration(seconds: 2),
        ),
  };

  @override
  void show({
    String msg,
    msgType = MsgType.common,
    VoidCallback onPressed,
  }) {
    assert(msg != null || msgType != null);

    final owner = snackOwner;
    print(" SnackBar owner is null? ${owner == null}");
    SnackBar snack;
    if (owner != null) {
      snack = owner.registeredSnackBarsBuilder[msgType](msg, onPressed);
    }
    print(" SnackBar is null? ${snack == null} by type = $msgType");

    _state?.hideCurrentSnackBar();
    Future.delayed(const Duration(milliseconds: 10), () {
      _state?.showSnackBar(
        snack ?? defaultSnackBarBuilder[msgType](msg),
      );
    });
  }
}

/// Типы сообщений
class MsgType extends Enum<String> {
  const MsgType(String value) : super(value);

  static const commonError = MsgType('commonError');
  static const common = MsgType('common');
}
