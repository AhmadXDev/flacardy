import 'package:flutter/material.dart';

extension Nav on BuildContext {
  push(Widget target) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => target));
  }

  pushOut(Widget target) {
    Navigator.pushAndRemoveUntil(this,
        MaterialPageRoute(builder: (context) => target), (route) => false);
  }
}
