import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/navigation/app_modules.dart';

void main() {
  runApp(ModularApp(module: AppModules(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      builder: (context, child) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
