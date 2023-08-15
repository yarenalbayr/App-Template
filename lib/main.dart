import 'package:app_template/core/navigation/app_modules.dart';
import 'package:app_template/view/auth/view/auth_state_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  runApp(
    ModularApp(
      module: AppModules(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      builder: (context, child) {
        return AuthStateListenerWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
