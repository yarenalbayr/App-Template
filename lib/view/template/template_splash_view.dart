import 'package:app_template/core/constants/string_constants.dart';
import 'package:app_template/core/extensions/index.dart';
import 'package:app_template/core/navigation/navigation_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemplateSplashView<B extends StateStreamable<S>, S>
    extends StatefulWidget {
  const TemplateSplashView({
    required this.onStateChange,
    required this.onFetch,
    required this.onError,
    super.key,
  });

  final void Function(S state) onStateChange;
  final void Function() onFetch;
  final Exception? Function(S s) onError;

  @override
  State<TemplateSplashView<B, S>> createState() =>
      _TemplateSplashViewState<B, S>();
}

class _TemplateSplashViewState<B extends StateStreamable<S>, S>
    extends State<TemplateSplashView<B, S>> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), widget.onFetch);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      bloc: context.get<B>(),
      listener: (context, state) {
        widget.onStateChange(state);
      },
      builder: (context, state) {
        final error = widget.onError(state);
        if (error != null) {
          return const Center(child: Text(StringConstants.error));
        }
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                StringConstants.loading,
              ),
              SizedBox(height: context.height * 0.1),
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
