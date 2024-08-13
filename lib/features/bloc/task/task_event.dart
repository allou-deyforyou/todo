part of 'task_bloc.dart';

class PutTaskIsarEvent extends BlocEvent {
  const PutTaskIsarEvent({
    required this.data,
    this.merged = false,
  });
  final bool merged;
  final List<Task> data;
}

class ClearTaskIsarEvent extends BlocEvent {
  const ClearTaskIsarEvent();
}

class DeleteTaskIsarEvent extends BlocEvent {
  const DeleteTaskIsarEvent({
    required this.data,
  });
  final List<Task> data;
}

class LoadListTaskIsarEvent extends BlocEvent {
  const LoadListTaskIsarEvent({
    this.fireImmediately = true,
    this.listen = true,
    this.limit = 100,
  });

  final bool fireImmediately;
  final bool listen;
  final int limit;
}

class LoadSingleTaskIsarEvent extends BlocEvent {
  const LoadSingleTaskIsarEvent({
    this.fireImmediately = true,
    this.listen = true,
    required this.task,
  });
  final bool fireImmediately;
  final bool listen;

  final Task task;
}
