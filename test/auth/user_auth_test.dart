// ignore_for_file: inference_failure_on_function_invocation

import 'package:app_template/logic/models/user_model.dart';
import 'package:app_template/logic/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late IAuthService authService;

  setUp(() {
    authService = AuthService();
  });

  test('Create user', () async {
    final result = await authService.createUserWithEmailAndPassword(
      email: 'test1@gmail.com',
      password: 'Abc123#',
    );

    result.fold(
      (l) => fail('Failed on creatign user: $l'),
      (r) => expect(r, isInstanceOf<UserModel>),
    );
  });
}
