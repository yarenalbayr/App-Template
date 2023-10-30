import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ieee_event_app/core/navigation/app_modules.dart';
import 'package:ieee_event_app/view/auth/view/auth_state_listener.dart';

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
