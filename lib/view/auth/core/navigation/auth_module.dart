// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter_modular/flutter_modular.dart';
import 'package:ieee_event_app/logic/blocs/user/user_bloc.dart';
import 'package:ieee_event_app/logic/services/auth/auth_service.dart';
import 'package:ieee_event_app/view/auth/view/login_view.dart';
import 'package:modular_bloc_bind/modular_bloc_bind.dart';

part 'auth_routes.dart';

class AuthModule extends Module {
  @override
  List<Bind> get binds => [
        Bind<IAuthService>((i) => AuthService()),
        BlocBind.singleton((i) => UserBloc(authService: i.get<IAuthService>())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          _RawAuthRoutes.login,
          child: (context, args) => const LoginView(),
        )
      ];
}
