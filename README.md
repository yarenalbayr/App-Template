
# App Template

An app template that can be used as a started of a project. Using [flutter modular](https://pub.dev/packages/flutter_modular) package for navigation and handling the separation of each logic and view by its own module.

For state management using [bloc](https://pub.dev/packages/bloc) package, well you know what it is capable of.

This template needs more integrations on views and more service calls can make it more effective.

## Firebase configuration

### IOS:

You will need to add `GoogleService-Info.plist` inside `ios/Runner/GoogleService-Info.plist`.

### Android:

You will need to add `google-services.json` inside `android/app/google-services.json`.

> Please verify if them in your `.gitignore`.

# Architecture and folder structure

Content table:

- [View](#ℹ️-modules)
- [Logic](#ℹ️-logic)
  - [Blocs (global)](#blocs-global)
  - [Models](#entities)
  - [Source](#sources)
  - [Services](#services)
- [Core](#ℹ️-core)
  - [Exceptions](#exceptions)
  - [Constants](#constants)
  - [Extensions](#extensions)
  - [Mixins](#mixins)
  - [Helpers](#helpers)
  - [Navigation](#navigation)
  - [Configurations](#configurations)

# ℹ️ `View`

Here we will put the screen of are module.

## Widgets

Here are the widgets that recurrently appear in the module's pages/modals and have been extracted to a separate component to be reused.

## View-Models

The View Models are structures that will help demonstrate logic produced by the screens.


## Core (Of module)

Similar to the "global" core shared between modules. 

### App routes file in navigation folder inside module

One difference between the "global" navigation folder for local is a routes file with the constant Strings of the routes.

> Remember to create a static `moduleName` string. It will be used in [global core](#navigation).

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

# ℹ️ `Logic`

## Sources

Will be the source the data that the app will use. This structure will bring the data that the services will manipulate. Each data in the app has to come from a source, such as api source, module_name source, etc.

Each `source file will have a interface and implementation` class.

For example:

```dart
abstract class IApiSource {
  Future<Either<CustomException, T> get<T>();
  Future<Either<CustomException, T> put<T>();
  Future<Either<CustomException, T> patch<T>();
  Future<Either<CustomException, T> delete<T>();
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
  Future<Either<CustomException, UserModel> getUserData();
}

class UserInfo implements IUserInfo {
  final IApiSource _api;
  const UserInfo({
    required IApiSource api,
  }) : _api = api;

  Future<Either<CustomException, UserModel> getUserData() {
    // If you want to make any logic and manipulate the data, feel free to do it here.
    return _api.get('users/info');
  }
}
```

# ℹ️ `Core`

Fundamental functionality to all the layers (being accessed by any of them). This functionality can not have bussiness logic. They are more like utilities like mixins, extensions, constants and other things that we will see below.

## Exceptions

Will contain all the typed errors. This error will be used to return as `left in the either` in the source and services classes. And that either will be handled in the bloc to notify the user of the error that had occurred.
In this file we will have the `custom_exception.dart` that contains the interface that will be the base of all failures. And inside the `failures/` folder we will create create specializations for each [source](#sources) and global mixin error, etc.

## Constants

Will handle all constants files. For example: _images_constants.dart_, _audio_constants.dart_ and _links_constants.dart_...


## Extensions

It will have all kinds of extensions available globally.

## UI

### Theme
We will be using dark theme and customized text and button styles with colors inside ColorConstants file.

### Components

## Navigation

In this folder we will put all navigation-related files.

In each navigation folder (whether in the global core or in the folder that [each module contains](#app-routes-file-in-navigation-folder-inside-module)) we will have a file with the module's configuration.

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

> To use the dependency:</br>
> final userBloc = context.get\<UserBloc>();

