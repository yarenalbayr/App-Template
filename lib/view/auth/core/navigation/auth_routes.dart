part of 'auth_module.dart';

class AuthRoutes {
  static const String moduleName = '/auth';
  static const String loginView = '$moduleName${_RawAuthRoutes.login}';
}

class _RawAuthRoutes {
  static const String login = '/login';
}
