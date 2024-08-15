import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../methods/firestore_methods.dart';
import '/skills/to_do/enums/priority_enum.dart';
import 'time_model.dart';
import 'time_period_model.dart';

class TaskFields {
  static const String title = 'title';
  static const String description = 'description';
  static const String isDone = 'isDone';
  static const String priority = 'priority';
  static const String parentTaskId = 'parentTaskId';
  static const String subTasks = 'subTasks'; // TODO name this subTasksIds
  static const String labels = 'labels';
}

class Task implements Comparable<Task> {
  String id; // firebase document id
  String title;
  String description;
  bool isDone;
  Priority priority;
  Time time;
  Task? parentTask;
  List<Task> subTasks = [];
  List<String> labels = [];

  Task({
    this.id = '',
    this.title = '',
    this.description = '',
    this.isDone = false,
    this.priority = Priority.none,
    this.parentTask,
    time,
    subTasks,
    labels,
  })  : time = time ?? Time(),
        subTasks = subTasks ?? [],
        labels = labels ?? [];

  TimePeriod get period => time.period;

  PickerDateRange get pickerPeriod =>
      PickerDateRange(period.plannedStart, null);

  bool get isRunning => time.isRunning;

  factory Task.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return Task(
      id: doc.id,
      title: data[TaskFields.title],
      description: data[TaskFields.description],
      isDone: data[TaskFields.isDone],
      priority: Priority.values[data[TaskFields.priority]],
      time: Time.fromFirestore(data),
      parentTask: data[TaskFields.parentTaskId] != null
          ? Task(id: data[TaskFields.parentTaskId])
          : null,
      subTasks:
          (data[TaskFields.subTasks] as List).map((e) => Task(id: e)).toList(),
      labels: data[TaskFields.labels] == null
          ? <String>[]
          : List<String>.from(data[TaskFields.labels]),
    );
  }

  static Future<void> loadSubTasksAndParent(Task task) async {
    var futures = task.subTasks.map((e) => Firestore.getTask(e.id)).toList();

    var subTasks = await Future.wait(futures);

    task.subTasks.clear();

    task.subTasks.addAll(subTasks.where((e) => e != null).cast<Task>());

    if (task.parentTask != null) {
      task.parentTask = await Firestore.getTask(task.parentTask!.id);
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      TaskFields.title: title,
      TaskFields.description: description,
      TaskFields.isDone: isDone,
      TaskFields.priority: priority.index,
      ...time.toFirestore(),
      TaskFields.parentTaskId: parentTask?.id,
      TaskFields.subTasks: subTasks.map((e) => e.id).toList(),
      TaskFields.labels: labels,
    };
  }

  @override
  int compareTo(Task other) {
    return time.compareTo(other.time);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    // TODO this may make infinite loop

    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isDone == isDone &&
        other.priority == priority &&
        other.time == time &&
        other.parentTask == parentTask &&
        listEquals(other.subTasks, subTasks);
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        isDone,
        priority,
        time,
        parentTask,
        Object.hashAll(subTasks),
      );

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, isDone: $isDone, priority: $priority, time: $time, parentTask: $parentTask, subTasks: $subTasks, labels: $labels)';
  }
}
