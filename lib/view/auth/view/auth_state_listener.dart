import 'dart:async';

import 'package:app_template/core/navigation/navigation_extension.dart';
import 'package:app_template/logic/blocs/user/user_bloc.dart';
import 'package:app_template/logic/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_modular/flutter_modular.dart';

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

    final isNoneUser = userBloc.state.maybeWhen(
      orElse: () => false,
      unauthenticated: () => true,
    );

    _userStateSubscription =
        FirebaseAuth.instance.userChanges().listen((fbUser) {
      if (fbUser != null && !isNoneUser) {
        final user = UserModel.fromFirebaseUser(fbUser);
        userBloc.add(UserEvent.registerUser(user: user));
      } else {
        userBloc.add(const UserEvent.unregisterUser());
      }
    });
  }

  @override
  void dispose() {
    _userStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      bloc: context.get<UserBloc>(),
      listener: (context, state) {
        state.mapOrNull(
          unauthenticated: (value) {
            Modular.to.navigate('/auth');
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
