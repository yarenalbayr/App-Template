import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ieee_event_app/logic/models/user_model.dart';
import 'package:ieee_event_app/logic/services/auth/auth_service.dart';

part 'user_bloc.freezed.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required IAuthService authService,
  })  : _authService = authService,
        super(const UserState.initial()) {
    on<_RegisterUser>(_onRegisterUser);
    on<_UnregisterUser>(_onUnregisterUser);
  }

  final IAuthService _authService;

  FutureOr<void> _onRegisterUser(
    _RegisterUser event,
    Emitter<UserState> emit,
  ) {
    emit(UserState.success(user: event.user));
  }

  FutureOr<void> _onUnregisterUser(
    _UnregisterUser event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserState.unauthenticated());
    await _authService.signOut();
  }
}
