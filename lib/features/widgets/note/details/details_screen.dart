part of 'details_widget.dart';

class DetailsTaskScreen extends StatefulWidget {
  const DetailsTaskScreen({
    super.key,
    required this.task,
  });

  final Task task;
  static const taskKey = 'task';

  static const path = 'task';
  static const name = 'task';
  @override
  State<DetailsTaskScreen> createState() => _DetailsTaskScreenState();
}

class _DetailsTaskScreenState extends State<DetailsTaskScreen> {
  /// [Assets]
  late Task _task;

  void _onEditPressed() {
    context.pushNamed(AddTaskScreen.name, extra: {
      AddTaskScreen.taskKey: _task,
    });
  }

  void _onDeletePressed() async {
    final data = await showDeleteTaskModal(context: context);
    if (data != null) {
      _deleteTask();
    }
  }

  /// [TaskLogic]
  late final TaskIsarBloc _taskIsarBloc;

  void _listenTaskIsarState(BuildContext context, BlocState state) {
    if (state case SuccessState<LoadSingleTaskIsarEvent, Task>(:final data)) {
      _task = data;
    } else if (state case SuccessState<DeleteTaskIsarEvent, List<Task>>()) {
      final localizations = context.localizations;
      showErrorSnackBar(
        text: localizations.taskdeleted(_task.title).capitalize(),
        context: context,
      );
      NotificationService.cancelNotification(id: _task.id!);
      context.pop();
    }
  }

  void _loadTask() {
    _taskIsarBloc.add(LoadSingleTaskIsarEvent(
      task: _task,
    ));
  }

  void _deleteTask() {
    _taskIsarBloc.add(DeleteTaskIsarEvent(
      data: [_task],
    ));
  }

  @override
  void initState() {
    super.initState();

    /// [Assets]
    _task = widget.task;

    /// [TaskLogic]
    _taskIsarBloc = TaskIsarBloc();
    _loadTask();
  }

  @override
  void dispose() {
    /// [Assets]
    _taskIsarBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
        bloc: _taskIsarBloc,
        listener: _listenTaskIsarState,
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    DetailsTaskSliverAppBar(
                      trailing: DetailsTaskEditButton(
                        onPressed: _onEditPressed,
                      ),
                    ),
                    DetailsTaskSliverWrapper(
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          SliverToBoxAdapter(
                            child: DetailsTaskTitleAndDescription(
                              description: _task.descriptionWidget(context),
                              title: _task.titleWidget(context),
                            ),
                          ),
                          const SliverPadding(
                            padding: kMaterialListPadding,
                          ),
                          SliverToBoxAdapter(
                            child: DetailsTaskDate(
                              date: _task.dateWidget(context),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: DetailsTaskPriority(
                              priority: _task.priorityWidget(context),
                              color: _task.priority.color(context),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: DetailsTaskDone(
                              done: _task.doneWidget(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  Widget? child;
                  VoidCallback? onPressed = _onDeletePressed;
                  if (state is PendingState<DeleteTaskIsarEvent>) {
                    child = const CupertinoActivityIndicator();
                    onPressed = null;
                  }
                  return DetailsTaskDeleteButton(
                    onPressed: onPressed,
                    child: child,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
