
import 'package:flutter/widgets.dart';

class AppL10n {
  AppL10n._();

  static AppL10n? _instance;

  static BuildContext? _contex;

  static AppL10n getInstance() {
    _instance ??= AppL10n._();

    return _instance!;
  }

  static getString() {

  }

}