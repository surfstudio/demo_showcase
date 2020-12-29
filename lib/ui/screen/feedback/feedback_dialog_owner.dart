import 'package:flutter/material.dart';
import 'package:demo_showcase/ui/base/owners/dialog_owner.dart';
import 'package:demo_showcase/ui/common/widgets/dialogs/thank_you_dialog.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class FeedbackDialogOwner with DialogOwner {
  @override
  Map<FeedbackDialogType, DialogBuilder<DialogData>> get registeredDialogs => {
        FeedbackDialogType.success: DialogBuilder<ThankYouDialogData>(
          _buildSuccessDialog,
        )
      };

  Widget _buildSuccessDialog(BuildContext context, {ThankYouDialogData data}) {
    return ThankYouDialog(data: data);
  }
}

enum FeedbackDialogType {
  /// Диалог успешной отправки обратной связи
  success,
}
