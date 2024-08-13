import 'package:bloc/bloc.dart';
import 'package:isar/isar.dart';
import 'package:todo/core/models/_models.dart';
import 'package:todo/core/services/_services.dart';

part 'task_event.dart';

class TaskIsarBloc extends Bloc<BlocEvent, BlocState> {
  TaskIsarBloc([super.initialState = const InitState()]) {
    on(handlePutTaskIsarEvent);
    on(handleClearTaskIsarEvent);
    on(handleDeleteTaskIsarEvent);
    on(handleLoadListTaskIsarEvent);
    on(handleLoadSingleTaskIsarEvent);
  }

  @override
  String toString() => 'TaskIsarBloc';

  static Future<void> handlePutTaskIsarEvent(
    PutTaskIsarEvent event,
    Emitter<BlocState> emit,
  ) async {
    try {
      emit(PendingState(event: event));

      List<Task> data = event.data;

      final ids = await IsarConfig.isar.writeTxn(() {
        return IsarConfig.isar.tasks.putAll(data);
      });

      data = List.generate(data.length, (index) => data[index].copyWith(id: ids[index]));

      emit(SuccessState(data, event: event));
    } catch (error) {
      emit(FailureState.internalError.copyWith(
        event: event,
      ));
    }
  }

  static Future<void> handleClearTaskIsarEvent(
    ClearTaskIsarEvent event,
    Emitter<BlocState> emit,
  ) async {
    try {
      emit(PendingState(event: event));

      await IsarConfig.isar.writeTxn(() {
        return IsarConfig.isar.tasks.clear();
      });

      emit(SuccessState(true, event: event));
    } catch (error) {
      emit(FailureState.internalError.copyWith(
        event: event,
      ));
    }
  }

  static Future<void> handleDeleteTaskIsarEvent(
    DeleteTaskIsarEvent event,
    Emitter<BlocState> emit,
  ) async {
    try {
      emit(PendingState(event: event));

      List<Task> data = event.data;
      final ids = List.of(data.map((item) => item.id).nonNulls);
      await IsarConfig.isar.writeTxn(() {
        return IsarConfig.isar.tasks.deleteAll(ids);
      });

      emit(SuccessState(data, event: event));
    } catch (error) {
      emit(FailureState.internalError.copyWith(
        event: event,
      ));
    }
  }

  static Future<void> handleLoadListTaskIsarEvent(
    LoadListTaskIsarEvent event,
    Emitter<BlocState> emit,
  ) async {
    try {
      emit(PendingState(event: event));
      var transactionBuilder = IsarConfig.isar.tasks.filter().idIsNotNull();

      final query = transactionBuilder.limit(event.limit);
      if (event.listen) {
        await emit.forEach(
          query.watch(fireImmediately: event.fireImmediately),
          onData: (data) {
            if (data.isEmpty) {
              return FailureState.noData.copyWith(
                event: event,
              );
            }
            return SuccessState(data, event: event);
          },
        );
      } else {
        if (event.fireImmediately) {
          final data = query.findAllSync();
          if (data.isEmpty) {
            emit(FailureState.noData.copyWith(
              event: event,
            ));
          } else {
            emit(SuccessState(data, event: event));
          }
        } else {
          final data = await query.findAll();
          if (data.isEmpty) {
            emit(FailureState.noData.copyWith(
              event: event,
            ));
          } else {
            emit(SuccessState(data, event: event));
          }
        }
      }
    } catch (error) {
      emit(FailureState.internalError.copyWith(
        event: event,
      ));
    }
  }

  static Future<void> handleLoadSingleTaskIsarEvent(
    LoadSingleTaskIsarEvent event,
    Emitter<BlocState> emit,
  ) async {
    try {
      emit(PendingState(event: event));
      var transactionBuilder = IsarConfig.isar.tasks.filter().idIsNotNull();

      transactionBuilder = transactionBuilder.idEqualTo(event.task.id!);

      Task? data;
      if (event.fireImmediately) {
        data = await transactionBuilder.findFirst();
      } else {
        data = transactionBuilder.findFirstSync();
      }

      if (data != null) {
        if (event.listen) {
          await emit.forEach(
            IsarConfig.isar.tasks.watchObject(
              fireImmediately: event.fireImmediately,
              data.id!,
            ),
            onData: (data) {
              if (data == null) {
                return FailureState.noData.copyWith(
                  event: event,
                );
              } else {
                return SuccessState(data, event: event);
              }
            },
          );
        } else {
          emit(SuccessState(data, event: event));
        }
      } else {
        emit(FailureState.noData.copyWith(
          event: event,
        ));
      }
    } catch (error) {
      emit(FailureState.internalError.copyWith(
        event: event,
      ));
    }
  }
}
