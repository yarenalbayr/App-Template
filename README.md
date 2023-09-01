
# App Template

An app template that can be used as starter of a project.

Mainly using [flutter modular](https://pub.dev/packages/flutter_modular) and [bloc](https://pub.dev/packages/bloc) packages for maintaing the app.

- For navigation, handling the separation of each logic and view by its own module using [flutter modular](https://pub.dev/packages/flutter_modular) package.

- For state management using [bloc](https://pub.dev/packages/bloc) package, well you know what it is capable of.

Right now it is using Firebase Auth as authentication however it is flexible so it can be changed by changing only service functions as you wish.

This template needs more integrations on views and service calls to be a part of a real project.

## Firebase configuration

### IOS:

You will need to add `GoogleService-Info.plist` inside `ios/Runner/GoogleService-Info.plist`.

### Android:

You will need to add `google-services.json` inside `android/app/google-services.json`.

> Please verify if them in your `.gitignore`.

# Architecture and folder structure

Content table:
- [Core](#ℹ️-core)
  - [Configurations](#configurations)
  - [Constants](#constants)
  - [Exceptions](#exceptions)
  - [Extensions](#extensions)
  - [Helpers](#helpers)
  - [Mixins](#mixins)
  - [Navigation](#navigation)
- [Logic](#ℹ️-logic)
  - [Blocs](#blocs-global)
  - [Models](#entities)
  - [Services](#services)
  - [Source](#sources)
- [View](#ℹ️-modules)





# ℹ️ `Core`

Fundamental functionality to all the layers (being accessed by any of them). This functionality can not have bussiness logic. They are more like utilities like mixins, extensions, constants and other things.

## Exceptions

Will contain all the typed errors. This error will be used to return as `left in the either` in the source and services classes. And that either will be handled in the bloc to notify the user of the error that had occurred.


## Constants

Will handle all constants files. For example: _images_constants.dart_, _audio_constants.dart_ and _links_constants.dart_...


## Extensions

It will have all kinds of extensions available globally.


## Navigation

In this folder we will put all navigation-related files.

In each navigation folder (whether in the global core or in the folder that each module contains we will have a file with the module's configuration.

Let's use the app_modules.dart as example.
But this is valid to all modules.

We will create the module class that will extend `Module` and put in the getter bind all the dependencies of that bind (services, blocs, etc.).
The app module is the root module so inside it we will have binds that all the modules will use. For example, a source module that makes access to a api (because all modules will use this source, all modules will make a call to an api). In a feature module (ex: auth_module.dart) we will have the local blocs of it, services that it will use, etc.

### Let's see a example of creating a module to auth feature in our app


```dart
class AuthModule extends Module {
  @override
  List<Bind> get binds {
    return [
      Bind<IAuthService>(
        (i) => AuthService(
          // Use `i` to get instance from previous module.
          // It is created in the example bellow.
          api: i<IApiSource>(),
        ),
      ),
    ];
  }

  @override
  List<ModularRoute> get routes {
    return [
      ChildRoute(
        RawAuthRoutes.login,
        child: (context, args) {
          return const LoginPage();
        },
      ),
    ];
  }
}
```


### Registering a feature module in the application's root module.

```dart
class AppModules extends Module {
  @override
  List<Bind> get binds {
    return [
      // Create a instance for this source that
      // will be used in a lot of modules.
      Bind<IApiSource>((i) => ApiSource(dio: Dio())),
    ];
  }

  @override
  List<ModularRoute> get routes {
    return [
      // Register the feature module
      ModuleRoute(
        AuthRoutes.moduleName, // Using the module name constant
        module: AuthModule() // The module
      ),
    ];
  }
}
```

# ℹ️ `Logic`

## Blocs 

Here we will put the more global blocs, that are used in multiple modules/pages.
For example: a bloc that will update the state of the app to a error page when it dosen't have internet. Despite being global, they work like normal module blocks so they don't manage business rules and are dependent of a service to do so.

## Models

The project models are the actual data that the [services](#services) will manipulate. They will be obtained by [sources](#sources).
## Sources

Will be the source the data that the app will use. This structure will bring the data that the services will manipulate. Each data in the app has to come from a source, such as api source, module_name source, etc.

Each `source file will have a interface and implementation` class.

For example:

```dart
abstract class IApiSource {
  Future<Either<Exception, T> get<T>();
  Future<Either<Exception, T> put<T>();
  Future<Either<Exception, T> patch<T>();
  Future<Either<Exception, T> delete<T>();
}

// Implementation in the same file, right below the interface.
class ApiSource implements IApiSource {
  ...
}
```


## Services

The services will manipulate the data and apply the business logic. This data will be retrieved from the sources. A service can have as many sources as needed, and in all source dependency injections we will use the interface of a source `and never it's implementation`.

For example:

```dart
abstract class IUserInfo {
  Future<Either<Exception, UserModel> getUserData();
}

class UserInfo implements IUserInfo {
  final IApiSource _api;
  const UserInfo({
    required IApiSource api,
  }) : _api = api;

  Future<Either<Exception, UserModel> getUserData() {
    // If you want to make any logic and manipulate the data, feel free to do it here.
    return _api.get('users/info');
  }
}
```

# ℹ️ `View`

Here we will put the screen of are module.

## View (Of module)
The ui of the screens
## Core (Of module)

Similar to the "global" core shared between modules but has more spesific usage by its own module. 

### App routes file in navigation folder inside module

For example:

```dart
class AuthRoutes {
  // Create a route with the called `moduleName`.
  static const String moduleName = '/auth';

  // Use the raw routes with the preffix of the moduleName.
  static final String login = '$moduleName$RawAuthRoutes.login';
  static final String signUp = '$moduleName$RawAuthRoutes.signUp';
}

// Create the routes
class RawAuthRoutes {
  static const String login = '/login';
  static const String signUp = '/signUp';

}
```

> To use the dependency:</br>
> final userBloc = context.get\<UserBloc>();

