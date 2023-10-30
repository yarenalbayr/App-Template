import 'package:flutter_modular/flutter_modular.dart';
import 'package:ieee_event_app/logic/blocs/home/home_bloc.dart';

class HomeModule extends Module {
  @override
  List<Bind> get binds => [
        Bind((i) => HomeBloc()),
      ];
}
