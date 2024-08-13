import 'dart:developer';

import 'package:bloc/bloc.dart';

class LogBlocObserver extends BlocObserver {
  const LogBlocObserver();

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    log('$bloc(${bloc.state}) Created', name: 'Bloc');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    log('$bloc($event) Executed', name: 'Bloc');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    log('${transition.event.runtimeType}(${transition.nextState})', name: 'Bloc');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('$bloc(${bloc.state}) Error', name: 'Bloc');

    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    log('$bloc(${bloc.state}) Closed', name: 'Bloc');

    super.onClose(bloc);
  }
}
