part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.registerUser({required UserModel user}) =
      _RegisterUser;

  const factory UserEvent.unregisterUser() = _UnregisterUser;
}
