import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jarvis_2/skills/to_do/methods/firestore_methods.dart';
import 'package:jarvis_2/skills/to_do/methods/time_methods.dart';

import '../enums/priority_enum.dart';
import '../models/task_model.dart';

const String todoistApiToken = '75080e7a87399c767c24335610c0271ab0caf46a';
const String todoistApiUrl = 'https://api.todoist.com/rest/v2/tasks';

Future<List<dynamic>> fetchTodoistTasks() async {
  print('Starting to fetch tasks...');
  final response = await http.get(
    Uri.parse(todoistApiUrl),
    headers: {'Authorization': 'Bearer $todoistApiToken'},
  );

  if (response.statusCode == 200) {
    print('Successfully fetched tasks.');
    // print('Response: ${response.body}');
    return json.decode(response.body);
  } else {
    print('Failed to fetch tasks. Status code: ${response.statusCode}');
    return [];
  }
}

Future<void> importAllTasks() async {
  print('Adding buy later task.');
  Task buyLaterTask = Task(title: 'Buy later'); // TODO pin this task
  final buyId = await Firestore.addTask(buyLaterTask);
  print('Added buy later task.');

  Map<String, List<String>> subtasks = {};

  final tasks = await fetchTodoistTasks();
  for (var i = 0; i < tasks.length; i++) {
    Task task = Task();
    task.title = tasks[i]['content'];
    if (tasks[i]['project_id'] == '2294247462') task.labels.add('bDay');
    const toBuyId = '2294257831';
    if (tasks[i]['project_id'] == toBuyId) {
      task.parentTask = Task(id: buyId);
    }
    // TODO find a better way to handle labels
    task.id = tasks[i]['id'].toString();
    task.description = tasks[i]['description'];
    task.isDone = tasks[i]['is_completed'];
    task.labels.addAll(List<String>.from(tasks[i]['labels']));
    if (task.parentTask == null) {
      task.parentTask = Task(id: tasks[i]['parent_id']);
      if (task.parentTask != null) {
        subtasks.putIfAbsent(task.parentTask!.id, () => []).add(task.id);
      }
    }

    switch (tasks[i]['priority']) {
      case 4:
        task.priority = Priority.p0;
        break;
      case 3:
        task.priority = Priority.p1;
        break;
      default:
        task.priority = Priority.none;
    }

    if (tasks[i]['due'] != null) {
      task.period.plannedStart = DateTime.parse(tasks[i]['due']['date']);
      final dateString = tasks[i]['due']['string'];
      taskToTime(dateString, task.time, []);
    }
    await Firestore.addTaskWithId(task);
    if (tasks[i]['project_id'] == toBuyId) {
      await Firestore.addSubTask(buyId, task.id);
    }

    print(tasks[i]);
    print(task);
  }

  for (var parentTaskId in subtasks.keys) {
    print(
        'Adding all ${subtasks[parentTaskId]!.length} subtasks to $parentTaskId.');
    for (var subTaskId in subtasks[parentTaskId]!) {
      await Firestore.addSubTask(parentTaskId, subTaskId);
    }
  }
  print('Done.');
}
