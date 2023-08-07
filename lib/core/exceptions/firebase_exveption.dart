import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class FirebaseExceptions implements Exception {
  const FirebaseExceptions({
    required this.error,
    required this.message,
    required this.description,
  });
  final String message;
  final String description;

  final FirebaseException error;
}

@immutable
class FirebaseStorageException extends FirebaseExceptions {
  const FirebaseStorageException({
    required this.error,
  }) : super(
          error: error,
          message:
              'An error occurred while handling Firebase Strorage: $error.',
          description: 'Try again latter. If the error persists, '
              'please contact support.',
        );

  @override
  final FirebaseException error;
}
