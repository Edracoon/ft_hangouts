import 'package:flutter/material.dart';

class HeaderColor with ChangeNotifier {
  MaterialAccentColor _headerColor = Colors.deepPurpleAccent;

  get headerColor => _headerColor;

  MaterialAccentColor updateColor(int colorId) {
    switch (colorId) {
      case 1:
        _headerColor = Colors.blueAccent;
        break;
      case 2:
        _headerColor = Colors.greenAccent;
        break;
      case 3:
        _headerColor = Colors.deepOrangeAccent;
        break;
      case 4:
        _headerColor = Colors.deepPurpleAccent;
        break;
    }
    notifyListeners();
    return _headerColor;
  }
}

HeaderColor headerColorGlobal = HeaderColor();