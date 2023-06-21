import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showEvDialog(BuildContext context, String content, String confirmBtnTxt,
    VoidCallback? onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.tips),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.of(context).pop(); // 关闭对话框
            },
          ),
          CupertinoDialogAction(
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              }

              Navigator.of(context).pop(); // 关闭对话框
            },
            child: Text(confirmBtnTxt),
          ),
        ],
      );
    },
  );
}
