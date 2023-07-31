import 'package:flutter/material.dart';

class ApplicationStart{
  const ApplicationStart._();

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
  }
}