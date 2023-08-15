
# App Template

## Firebase configuration

### IOS:

You will need to add `GoogleService-Info.plist` inside `ios/Runner/GoogleService-Info.plist`.
> ` Please verify if it is in your `.gitignore`.

### Android:

You will need to add `google-services.json` inside `android/app/google-services.json`.

> Please verify if it is in your `.gitignore`.

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

For exemple:

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

> In this architecture, we will the convention of _"I" in the start of the interface_ and _"Impl" in the end of the implemantation_.

> `Important`: All functions in a source api should return a Either that has as left exception (returned in case of error) and the desired response in right. That way will force the user of this function to manage the error.

## Services

The services will manipulate the data and apply the business logic. This data will be retrieved from the sources. A service can have as many sources as needed, and in all source dependency injections we will use the interface of a source `and never it's implementation`.

For exemple:

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

Will handle all constants files. For exemple: _images_constants.dart_, _audio_constants.dart_ and _links_constants.dart_...


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

Wee will create the module class that will extend `Module` and put in the getter bind all the dependencies of that bind (services, blocs, etcs...).
The app module is the root module so inside it we will have binds that all the modules will use. For example, a source module that makes access to a api (because all modules will use this source, all modules will make a call to an api). In a feature module (ex: auth_module.dart) we will have the local blocs of it, services that it will use, etc.

### Let's see a example of creating a module to auth feature in our app

`Important`: You **need** to know [flutter modular](https://pub.dev/packages/flutter_modular). It's quite easy to use, maybe just by reading the references below you'll already
understand it. But if you have any questions, go read the [documentation](https://modular.flutterando.com.br/docs/flutter_modular/start/).

> Note: The source, in this exemple bellow, api source, was already instantiated before in the modular structure. That's because it was instanciated in the app_module.dart module. So i can retrive that instance using the i() that modular gives to us.

```dart
class AuthModule extends Module {
  @override
  List<Bind> get binds {
    return [
      Bind<IAuthService>(
        (i) => AuthService(
          // Use `i` to get instance from previous module.
          // It is created in the exemple bellow.
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

> The childs will all contain the Raw route constant of string.

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

> The moduleName will be used in app_module.dart as the name of the module.

> These string route constants were created [here](#app-routes-file-in-navigation-folder-inside-module).

> To use the dependency:</br>
> final userBloc = context.get\<UserBloc>();

## Localization

We'll use Easy Localization package for localize our strings in the app.

On the asset/lang folder inside en-US.json file we should add the string variable name and what it refers to.

Then we should run a script to generate strings from that json file.

I have added scripts/localization.sh folder to make it easy to run the generator function

We can run it with:

```
sh scripts/localization.sh
```

Then it automaticaly generates the locale strings from it to:
lib/core/configurations/localization/locale_keys.g.dart


To use it through the app we run:
```dart 
Text(LocaleKeys.myYodl.locale)
```


LocalizationManager holds the supported languages in it, to change the localization we call:

```dart
  context.locale = LanguageManager.instance.enLocale
```

We can also create linked translations like so:
```dart
{
  "example": {
    "hello": "Hello",
    "world": "World!",
    "helloWorld": "@:example.hello @:example.world"
  }
}
```