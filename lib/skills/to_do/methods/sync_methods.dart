import 'package:hive_local_storage/hive_local_storage.dart';

import '../enums/action_enum.dart';
import '../models/log_model.dart';
import '../models/task_model.dart';
import 'firestore_methods.dart';

class SyncFields {
  static const String sync = 'sync';
  static const String toUpload = 'toUpload';
  static const String tasks = 'tasks';
}

class Sync {
  static Box<dynamic> syncBox = Hive.box(SyncFields.sync);
  static List<Log> toUpload = [];
  static Map<String, Task> tasks = {};

  static Future<void> loadStorage() async {
    tasks = Map<String, Task>.from(
      syncBox.get(SyncFields.tasks, defaultValue: {}),
    );
  }

  static Future<void> syncWithoutGetTasks() async {
    // TODO solve changing tasks locally and on server by using date from log

    await upload();

    await download();
  }

  static Future<void> sync() async {
    await loadStorage();
    await syncWithoutGetTasks();
  }

  static Future<void> upload() async {
    // TODO do this faster using batch
    toUpload = List<Log>.from(
      syncBox.get(SyncFields.toUpload, defaultValue: []),
    );

    for (var log in toUpload) {
      switch (log.action) {
        case Action.create:
          await Firestore.addTask(tasks[log.taskId]!);
          break;
        case Action.update:
          await Firestore.updateTask(tasks[log.taskId]!);
          break;
        case Action.delete:
          await Firestore.deleteTask(log.taskId);
          break;
      }
    }

    toUpload = [];
    syncBox.put(SyncFields.toUpload, toUpload);
  }

  static Future<void> download() async {
    print('starting download');
    // TODO do this faster using batch
    List<Log> logs = await Firestore.getLogs();

    for (var log in logs) {
      switch (log.action) {
        case Action.create:
          tasks[log.taskId] = (await Firestore.getTask(log.taskId))!;
          break;
        case Action.update:
          tasks[log.taskId] = (await Firestore.getTask(log.taskId))!;
          break;
        case Action.delete:
          tasks.remove(log.taskId);
          break;
      }
    }

    syncBox.put(SyncFields.tasks, tasks);
    await Firestore.clearLogs();
    print('done download');
  }
}
