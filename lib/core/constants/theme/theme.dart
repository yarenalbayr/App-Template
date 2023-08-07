import 'package:flutter/material.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
}

ThemeData get darkTheme => ThemeData(
  
);
