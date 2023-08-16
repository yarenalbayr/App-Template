import 'dart:async';

import 'package:app_template/core/navigation/navigation_extension.dart';
import 'package:app_template/logic/blocs/home/home_bloc.dart';
import 'package:app_template/logic/blocs/user/user_bloc.dart';
import 'package:app_template/logic/models/user_model.dart';
import 'package:app_template/view/auth/core/navigation/auth_module.dart';
import 'package:app_template/view/home/core/navigation/home_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_modular/flutter_modular.dart';

///Listens to state changes of user from firebase if user is null navigates to
///login if user exist navigates to home view
class AuthStateListenerWrapper extends StatefulWidget {
  const AuthStateListenerWrapper({required this.child, super.key});

  final Widget child;

  @override
  State<AuthStateListenerWrapper> createState() =>
      _AuthStateListenerWrapperState();
}

class _AuthStateListenerWrapperState extends State<AuthStateListenerWrapper> {
  late final StreamSubscription<User?> _userStateSubscription;

  @override
  void initState() {
    super.initState();

    final userBloc = context.get<UserBloc>();
    final homeBloc = context.get<HomeBloc>();

    final isNoneUser = userBloc.state.maybeWhen(
      orElse: () => false,
      unauthenticated: () => true,
    );

    _userStateSubscription =
        FirebaseAuth.instance.userChanges().listen((fbUser) {
      if (fbUser != null && !isNoneUser) {
        final user = UserModel.fromFirebaseUser(fbUser);
        userBloc.add(UserEvent.registerUser(user: user));
        homeBloc.add(const HomeEvent.fetchHomeData());
      } else {
        userBloc.add(const UserEvent.unregisterUser());
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      bloc: context.get<UserBloc>(),
      listener: (context, state) {
        state.mapOrNull(
          unauthenticated: (value) {
            Modular.to.navigate(AuthRoutes.loginView);
          },
        );
      },
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          state.mapOrNull(
            success: (value) {
              Modular.to.navigate(AuthRoutes.splashView);
            },
          );
        },
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _userStateSubscription.cancel();
    super.dispose();
  }
}
