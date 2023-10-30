import 'package:app_template/core/navigation/navigation_extension.dart';
import 'package:app_template/logic/blocs/user/user_bloc.dart';
import 'package:app_template/logic/models/user_model.dart';
import 'package:flutter/material.dart';

extension UserExtension on BuildContext {
  UserModel get userCredentials {
    return get<UserBloc>().state.map(
          success: (value) => value.user,
          unauthenticated: (value) => throw Exception('User not logged in'),
          error: (value) => throw Exception('User not logged in'),
          loading: (value) => throw Exception('User not logged in'),
          initial: (value) => throw Exception('User not logged in'),
        );
  }

  UserModel? get userCredentialsOrNull {
    return get<UserBloc>().state.userCredentialsOrNull;
  }
}

extension UserBlocExtension on UserState {
  UserModel? get userCredentialsOrNull => mapOrNull(
        success: (value) => value.user,
      );
}
