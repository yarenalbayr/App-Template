import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CredentialAuthException implements Exception {
  const CredentialAuthException({
    required this.message,
    required this.description,
    required this.code,
  });
  factory CredentialAuthException.fromFirebaseError(
    FirebaseAuthException error,
  ) {
    if (error.code.contains('account-exists-with-different-credential')) {
      return CredentialAccountExistsWithADiferent(error);
    } else if (error.code.contains('email-already-in-use')) {
      return CredentialEmailAlreadyExists(error);
    } else if (error.code.contains('invalid-email')) {
      return CredentialInvalidEmail(error);
    } else if (error.code.contains('invalid-password')) {
      return CredentialInvalidPassword(error);
    } else if (error.code.contains('invalid-display-name')) {
      return CredentialInvalidUserName(error);
    } else if (error.code.contains('user-not-found')) {
      return CredentialUserNotFound(error);
    } else if (error.code.contains('wrong-password')) {
      return CredentialWrongPassword(error);
    } else if (error.code.contains('too-many-requests')) {
      return CredentialToManyRequest(error);
    } else if (error.code.contains('weak-password')) {
      return CredentialToManyRequest(error);
    } else {
      return CredentialUnknownFailure(error);
    }
  }
  final String message;
  final String description;

  /// The code of the error. We will use it to typify the error later.
  final String code;
}

@immutable
abstract class GoogleAuthException implements Exception {
  const GoogleAuthException({
    required this.message,
    required this.description,
  });
  final String message;
  final String description;
}

@immutable
class DidNotSelectAnAccount extends GoogleAuthException {
  const DidNotSelectAnAccount()
      : super(
          message: 'No account selected',
          description: 'Please select an google account',
        );
}

@immutable
class AccountWithoutDefaultProfile extends GoogleAuthException {
  const AccountWithoutDefaultProfile()
      : super(
          message: 'Error occurred while defining user profile',
          description: 'Please contact support to fix this error',
        );
}

@immutable
class CredentialAccountExistsWithADiferent extends CredentialAuthException {
  CredentialAccountExistsWithADiferent(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'This account already exists with a different credential',
          description: 'You have already created a account with this '
              'email credential in a diferent sing up method.\nFor exemple: '
              'You created a kharazan account, and now are trying to create '
              'a another account with a different form of login, for exemple, '
              'with Facebook.',
        );
}

@immutable
class CredentialEmailAlreadyExists extends CredentialAuthException {
  CredentialEmailAlreadyExists(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'Email already used',
          description: 'You provided email is already in use by an existing '
              'user. Each user must have a unique email.',
        );
}

@immutable
class CredentialInvalidEmail extends CredentialAuthException {
  CredentialInvalidEmail(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'Invalid email',
          description: 'You can not use this password. Try another one.',
        );
}

@immutable
class CredentialInvalidPassword extends CredentialAuthException {
  CredentialInvalidPassword(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'Invalid password',
          description: 'You can not use this password. Try another one.',
        );
}

@immutable
class CredentialInvalidUserName extends CredentialAuthException {
  CredentialInvalidUserName(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'Invalid User Name',
          description: 'You can not use this User Name. Try another one.',
        );
}

@immutable
class CredentialToManyRequest extends CredentialAuthException {
  CredentialToManyRequest(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'You eceded the number of attempts',
          description: 'You got the password wrong multiple times. '
              'For security, we block login attempts on this '
              'device for a while. Try again later...',
        );
}

@immutable
class WeekPassword extends CredentialAuthException {
  WeekPassword(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'Your password is too weak',
          description: 'Please type a more strong password.',
        );
}

@immutable
class CredentialUserNotFound extends CredentialAuthException {
  CredentialUserNotFound(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'No user found with those credentials',
          description: 'No user found with those credentials.\n'
              'Check that you typed your email and password correctly.\n'
              "Don't have an account? Create one right now!",
        );
}

class AuthUserNotFound extends CredentialAuthException {
  const AuthUserNotFound()
      : super(
          code: 'User is null.',
          message: 'User not found',
          description: 'Your account has been disabled.\n'
              'Contact support to recover your account.',
        );
}

@immutable
class CredentialWrongPassword extends CredentialAuthException {
  CredentialWrongPassword(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'Wrong password',
          description: 'Check that you typed your password correctly.\n'
              "Don't remember the password? Click on forgot "
              'my password to recover it.',
        );
}

@immutable
class CredentialUnknownFailure extends CredentialAuthException {
  CredentialUnknownFailure(FirebaseAuthException error)
      : super(
          code: error.code,
          message: 'An unknown error has occurred',
          description: 'Try again. You can also try closing the '
              'application. If the error persists, contact support.',
        );
}

@immutable
class UnknownError extends GoogleAuthException {
  const UnknownError()
      : super(
          message: 'An unknown error has occurred.',
          description: 'Try again.',
        );
}
