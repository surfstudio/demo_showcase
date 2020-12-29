import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';

/// Эмуляция BaseDialogController приложения
class DefaultDialogController implements DialogController {

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final BuildContext _context;
  final dialogOwner;

  DefaultDialogController(this._scaffoldKey, {this.dialogOwner})
      : assert(_scaffoldKey != null),
        _context = null;

  DefaultDialogController.from(this._context, {this.dialogOwner})
      : assert(_context != null),
        _scaffoldKey = null;

  @override
  Future<R> showAlertDialog<R>({
    String title,
    String message,
    void Function(BuildContext context) onAgreeClicked,
    void Function(BuildContext context) onDisagreeClicked,
  }) async {
    return null;
  }

  @override
  Future<R> showSheet<R>(Object type, {onDismiss, DialogData data}) async {
    return null;
  }

  @override
  Future<R> showModalSheet<R>(
    Object type, {
    DialogData data,
    bool isScrollControlled,
  }) async {
    return null;
  }
}
