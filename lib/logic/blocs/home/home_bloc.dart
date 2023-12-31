import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.dart';
part 'home_event.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState.initial()) {
    on<_FetchHomeData>(_fetchHomeData);
  }

  Future<FutureOr<void>> _fetchHomeData(
    _FetchHomeData event,
    Emitter<HomeState> emit,
  ) {
    emit(const HomeState.loading());
    throw UnimplementedError();
  }
}
