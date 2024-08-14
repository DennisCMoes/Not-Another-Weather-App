import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  EdgeInsets get padding => MediaQuery.of(this).padding;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
