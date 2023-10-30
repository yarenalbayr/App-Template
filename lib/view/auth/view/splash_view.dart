import 'package:app_template/core/navigation/navigation_extension.dart';
import 'package:app_template/logic/blocs/home/home_bloc.dart';
import 'package:app_template/view/home/core/navigation/home_routes.dart';
import 'package:app_template/view/template/template_splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.get<HomeBloc>();
    return TemplateSplashView<HomeBloc, HomeState>(
      onError: (s) => s.mapOrNull(
        error: (value) => value.exception,
      ),
      onFetch: () {
        homeBloc.add(const HomeEvent.fetchHomeData());
      },
      onStateChange: (state) {
        state.mapOrNull(
          success: (value) => Modular.to.navigate(HomeRoutes.home),
        );
      },
    );
  }
}
