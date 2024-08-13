import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import '_services.dart';

Future<void> runService(MyService service) async {
  WidgetsFlutterBinding.ensureInitialized();

  await service.beforeBinding();
  if (kReleaseMode) {
    await service.productionBinding();
  } else {
    await service.developmentBinding();
  }
  await service.afterBinding();
}

class MyService {
  const MyService();

  Future<void> beforeBinding() async {
    Bloc.observer = const LogBlocObserver();
  }

  Future<void> developmentBinding() {
    return Future.wait([
      NotificationService.development(),
      IsarConfig.development(),
      HiveConfig.development(),
    ]);
  }

  Future<void> productionBinding() {
    return Future.wait([
      NotificationService.production(),
      IsarConfig.production(),
      HiveConfig.production(),
    ]);
  }

  Future<void> afterBinding() async {}
}
