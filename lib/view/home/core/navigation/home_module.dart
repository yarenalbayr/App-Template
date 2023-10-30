import 'package:app_template/logic/blocs/home/home_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => HomeBloc()),
      ];
}
