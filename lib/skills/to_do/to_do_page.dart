import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../global/global_variables.dart';
import '../../global/page_abstract.dart';
import './models/task_model.dart';
import 'methods/firestore_methods.dart';
import 'methods/sync_methods.dart';
import 'widgets/task_list.dart';

class ToDoPage extends BasePage {
  @override
  String get title => 'ToDo';
  @override
  IconData get icon => Icons.checklist;

  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  bool _isSyncing = false;
  final List<Task> _tasks = [];
  final ChangeNotifier _addTaskNotifier = ChangeNotifier();

  Future<void> _syncTasks() async {
    if (_isSyncing) return;

    setState(() => _isSyncing = true);
    try {
      var newTasks = await Firestore.getTasks();
      newTasks.sort((a, b) => a.compareTo(b));
      final newTasksMap = {for (var task in newTasks) task.id: task};

      // remove
      for (int i = 0; i < _tasks.length; i++) {
        if (!newTasksMap.containsKey(_tasks[i].id)) {
          _tasks.removeAt(i);
          i--;
        }
      }

      // add or update
      for (int i = 0; i < newTasks.length; i++) {
        if (i >= _tasks.length) {
          _tasks.add(newTasks[i]);
        } else if (newTasks[i] != _tasks[i]) {
          _tasks[i] = newTasks[i];
        }
      }

      final now = DateTime.now();

      for (var task in _tasks) {
        if (task.period.plannedStart != null &&
            task.period.plannedStart!
                .isBefore(DateTime(now.year, now.month, now.day - 1))) {
          task.period.toOrder = true;
          setState(() {});
          await Firestore.updateTask(task);
        }
        await Task.loadSubTasksAndParent(task);
      }
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
        content: Text('Error syncing tasks: $e'),
      ));
    }
    setState(() => _isSyncing = false);
  }

  @override
  void initState() {
    Sync.loadStorage();
    Sync.syncWithoutGetTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CallbackShortcuts(
        bindings: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyQ):
              _addTaskNotifier.notifyListeners,
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  children: [
                    const Text('Order by '),
                    const Text('date'), // TODO
                    const Spacer(),
                    IconButton(
                      onPressed: _isSyncing ? null : _syncTasks,
                      icon: _isSyncing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(Icons.sync),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TaskList(
                  _tasks,
                  _addTaskNotifier,
                  syncTasks: _syncTasks,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskNotifier.notifyListeners,
        child: const Icon(Icons.add),
      ),
    );
  }
}
