part of 'add_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key,
    required this.task,
  });

  final Task? task;
  static const taskKey = 'task';

  static const path = 'add/task';
  static const name = 'add-task';
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  /// [Assets]
  late final GlobalKey<FormState> _formKey;

  late final Task? _task;

  late final ValueNotifier<Priority> _priorityController;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final ValueNotifier<DateTime?> _deadlineController;

  Priority? get _priority => _priorityController.value;

  String? get _title {
    final title = _titleController.text.trim();
    return title.isNotEmpty ? title : null;
  }

  String? get _description {
    final description = _descriptionController.text.trim();
    return description.isNotEmpty ? description : null;
  }

  DateTime? get _deadline => _deadlineController.value;

  bool get _isEdited {
    return [
      _title,
      _description,
      _deadline,
    ].nonNulls.isNotEmpty;
  }

  void _onPopInvokedWithResult(bool didPop, Task? result) async {
    if (didPop || result != null) return;
    final data = await showExitModal(context: context);
    if (data != null && mounted) {
      Navigator.pop(context);
    }
  }

  ValueChanged<Priority> _onPriorityChanged(Priority priority) {
    return (value) => _priorityController.value = value;
  }

  VoidCallback? _onDeadlineChanged(DateTime? deadline) {
    return () async {
      final data = await showCustomDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        context: context,
      );
      if (data != null) {
        _deadlineController.value = data;
      }
    };
  }

  void _onSubmitPressed() {
    if (_formKey.currentState!.validate()) {
      if (_task != null) {
        _updateTask();
      } else {
        _createTask();
      }
    }
  }

  /// [TaskLogic]
  late final TaskIsarBloc _taskIsarBloc;

  void _listenTaskIsarState(BuildContext context, BlocState state) {
    if (state case SuccessState<PutTaskIsarEvent, List<Task>>(:final data)) {
      final localizations = context.localizations;

      final task = data.first;
      if (_task != null) {
        showSuccessSnackBar(
          text: localizations.taskedited(task.title).capitalize(),
          context: context,
        );
      } else {
        showSuccessSnackBar(
          text: localizations.taskcreated(task.title).capitalize(),
          context: context,
        );
      }
      if (!task.done) {
        NotificationService.showNotification(
          body: localizations.taskreminder(task.title).capitalize(),
          title: localizations.reminder.capitalize(),
          dateTime: task.deadline,
          fixed: false,
          id: task.id!,
        );
      }

      context.pop(task);
    }
  }

  void _createTask() {
    final now = DateTime.now();
    _taskIsarBloc.add(
      PutTaskIsarEvent(data: [
        Task(
          title: _title!,
          priority: _priority!,
          deadline: _deadline ?? DateUtils.dateOnly(now),
          description: _description,
          createdAt: now,
          updatedAt: now,
        ),
      ]),
    );
  }

  void _updateTask() {
    final now = DateTime.now();
    _taskIsarBloc.add(
      PutTaskIsarEvent(data: [
        _task!.copyWith(
          title: _title!,
          priority: _priority!,
          deadline: _deadline,
          description: _description,
          updatedAt: now,
        ),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();

    /// [Assets]
    _formKey = GlobalKey<FormState>();

    _task = widget.task;

    _priorityController = ValueNotifier<Priority>(_task?.priority ?? Priority.values.first);
    _titleController = TextEditingController(text: _task?.title);
    _descriptionController = TextEditingController(text: _task?.description);
    _deadlineController = ValueNotifier<DateTime?>(_task?.deadline);

    /// [TaskLogic]
    _taskIsarBloc = TaskIsarBloc();
  }

  @override
  void dispose() {
    /// [Assets]
    _priorityController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _deadlineController.dispose();

    /// [TaskLogic]
    _taskIsarBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sliverSpace = SliverPadding(padding: kMaterialListPadding / 2);
    return ListenableBuilder(
      listenable: Listenable.merge([
        _titleController,
        _descriptionController,
        _deadlineController,
      ]),
      builder: (context, child) {
        return PopScope<Task>(
          canPop: !_isEdited,
          onPopInvokedWithResult: _onPopInvokedWithResult,
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: CustomScrollView(
                      slivers: [
                        if (_task != null) const AddTaskUpdateSliverAppBar() else const AddTaskSliverAppBar(),
                        AddTaskSliverWrapper(
                          sliver: SliverMainAxisGroup(
                            slivers: [
                              SliverToBoxAdapter(
                                child: ValueListenableBuilder(
                                  valueListenable: _priorityController,
                                  builder: (context, priority, child) {
                                    return AddTaskPrioritySegmentedButton(
                                      segments: List.of(Priority.values.map((item) => item.buttonSegment(context))),
                                      selectedBackgroundColor: priority.color(context),
                                      onChanged: _onPriorityChanged(priority),
                                      selected: priority,
                                    );
                                  },
                                ),
                              ),
                              sliverSpace,
                              SliverToBoxAdapter(
                                child: AddTaskTitleTextField(
                                  controller: _titleController,
                                ),
                              ),
                              sliverSpace,
                              SliverToBoxAdapter(
                                child: AddTaskDescriptionTextField(
                                  controller: _descriptionController,
                                ),
                              ),
                              sliverSpace,
                              SliverToBoxAdapter(
                                child: ValueListenableBuilder(
                                  valueListenable: _deadlineController,
                                  builder: (context, deadline, child) {
                                    return AddTaskDateTextField(
                                      onTap: _onDeadlineChanged(deadline),
                                      initialValue: deadline?.format,
                                      key: ValueKey(deadline),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocConsumer(
                  bloc: _taskIsarBloc,
                  listener: _listenTaskIsarState,
                  builder: (context, state) {
                    Widget? child;
                    VoidCallback? onPressed = _onSubmitPressed;
                    if (state is PendingState) {
                      child = const CupertinoActivityIndicator();
                      onPressed = null;
                    }
                    if (_task != null) {
                      return AddTaskUpdateButton(
                        onPressed: onPressed,
                        child: child,
                      );
                    }
                    return AddTaskCreateButton(
                      onPressed: onPressed,
                      child: child,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
