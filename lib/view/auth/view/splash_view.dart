import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ieee_event_app/core/navigation/navigation_extension.dart';
import 'package:ieee_event_app/logic/blocs/home/home_bloc.dart';
import 'package:ieee_event_app/view/home/core/navigation/home_routes.dart';
import 'package:ieee_event_app/view/template/template_splash_view.dart';

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
