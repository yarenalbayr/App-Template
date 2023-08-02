import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

extension BuildContextExtension on BuildContext {
  T get<T extends Object>() => read<T>();
}
