part of 'home_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const path = '/';
  static const name = 'home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// [Assets]

  int _sortTask(Task a, Task b) {
    return a.deadline.compareTo(b.deadline);
  }

  void _requestNotificationPermission() {
    if (HiveConfig.notifications == null) {
      Permission.notification
          .onGrantedCallback(
            () => HiveConfig.notifications = true,
          )
          .onDeniedCallback(
            () => showNotificationWarningModal(context: context),
          )
          .onPermanentlyDeniedCallback(
            () => HiveConfig.notifications = false,
          )
          .request();
    }
  }

  void _onMenuPressed() {
    context.pushNamed(SettingsScreen.name);
  }

  void _onAddPressed() {
    context.pushNamed(AddTaskScreen.name);
  }

  VoidCallback? _onTaskPressed(Task task) {
    return () {
      context.pushNamed(DetailsTaskScreen.name, extra: {
        DetailsTaskScreen.taskKey: task,
      });
    };
  }

  ValueChanged<bool?>? _onTaskChanged(Task task) {
    return (value) {
      HapticFeedback.selectionClick();
      _updateTask(task.copyWith(done: value));
    };
  }

  /// [TaskLogic]
  late final TaskIsarBloc _taskIsarBloc;
  late List<List<Task>> _taskGroupList;

  void _listenTaskIsarState(BuildContext context, BlocState state) {
    if (state case SuccessState<LoadListTaskIsarEvent, List<Task>>(:final data)) {
      _taskGroupList = data.group((a, b) => DateUtils.dateOnly(a.deadline).isAtSameMomentAs(DateUtils.dateOnly(b.deadline)));
    } else if (state case SuccessState<PutTaskIsarEvent, List<Task>>(:final data)) {
      final task = data.first;
      NotificationService.cancelNotification(id: task.id!);
    } else if (state case FailureState<LoadListTaskIsarEvent>()) {
      switch (state) {
        case FailureState.noData:
          _taskGroupList = List<List<Task>>.empty();
          break;
        default:
      }
    }
  }

  void _loadTask() {
    _taskIsarBloc.add(const LoadListTaskIsarEvent());
  }

  void _updateTask(Task task) {
    final now = DateTime.now();
    _taskIsarBloc.add(
      PutTaskIsarEvent(data: [
        task.copyWith(
          updatedAt: now,
        ),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();

    /// [Assets]
    _requestNotificationPermission();

    /// [TaskLogic]
    _taskIsarBloc = TaskIsarBloc();
    _taskGroupList = List<List<Task>>.empty();
    _loadTask();
  }

  @override
  void dispose() {
    /// [TaskLogic]
    _taskIsarBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeSliverAppBar(
            leading: HomeMenuButton(
              onPressed: _onMenuPressed,
            ),
            trailing: HomeAddButton(
              onPressed: _onAddPressed,
            ),
          ),
          HomeSliverWrapper(
            sliver: BlocConsumer(
              bloc: _taskIsarBloc,
              listener: _listenTaskIsarState,
              builder: (context, state) {
                if (_taskGroupList.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const HomeTaskEmptyMessage(),
                        HomeAddTaskButton(
                          onPressed: _onAddPressed,
                        ),
                      ],
                    ),
                  );
                }
                return DefaultTabController(
                  length: _taskGroupList.length,
                  child: Builder(
                    builder: (context) {
                      final controller = DefaultTabController.of(context);
                      return ListenableBuilder(
                        listenable: controller,
                        builder: (context, child) {
                          final currentIndex = controller.index;
                          final taskList = _taskGroupList[currentIndex];
                          taskList.sort(_sortTask);
                          return SliverMainAxisGroup(
                            slivers: [
                              SliverPinnedHeader(
                                child: ListenableBuilder(
                                  listenable: controller,
                                  builder: (context, child) {
                                    return HomeDateListView(
                                      itemCount: _taskGroupList.length,
                                      itemBuilder: (context, index) {
                                        final item = _taskGroupList[index].first;
                                        return HomeDateChip(
                                          onSelected: (value) => controller.animateTo(index),
                                          selected: index == currentIndex,
                                          dateTime: item.deadline,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SliverPadding(
                                padding: kMaterialListPadding,
                              ),
                              HomeTaskSliverListView(
                                itemCount: taskList.length,
                                itemBuilder: (context, index) {
                                  final item = taskList[index];
                                  return HomeTaskCard(
                                    value: item.done,
                                    onChanged: _onTaskChanged(item),
                                    onPressed: _onTaskPressed(item),
                                    title: item.titleWidget(context),
                                    trailing: item.timeWidget(context),
                                    color: item.priority.color(context),
                                  );
                                },
                              ),
                              const SliverSafeArea(
                                top: false,
                                sliver: SliverPadding(
                                  padding: kMaterialListPadding,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
