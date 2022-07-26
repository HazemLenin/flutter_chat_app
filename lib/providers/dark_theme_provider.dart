import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class DarkThemeProvider with ChangeNotifier {
  bool enabled = true;

  toggleDarkTheme() {
    enabled = !enabled;
    notifyListeners();
  }
}