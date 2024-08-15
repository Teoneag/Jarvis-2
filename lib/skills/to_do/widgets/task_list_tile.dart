import 'package:flutter/material.dart';

import 'package:jarvis_2/skills/to_do/enums/priority_enum.dart';
import '../methods/firestore_methods.dart';
import '../methods/time_methods.dart';
import '../models/task_model.dart';

class TaskListTile extends StatefulWidget {
  final Task task;
  final void Function() deleteTask;
  final void Function() completeTask;
  const TaskListTile(this.task, this.deleteTask, this.completeTask,
      {super.key});

  @override
  State<TaskListTile> createState() => _TaskListTileState();
}

class _TaskListTileState extends State<TaskListTile> {
  Future<void> _start() async {
    widget.task.time.periods[0].actualStart = DateTime.now();
    setState(() {});
    await Firestore.updateTask(widget.task);
  }

  Future<void> _stop() async {
    widget.task.period.actualEnd = DateTime.now();
    completeTask(widget.task);
    widget.completeTask();
    setState(() {});
    await Firestore.updateTask(widget.task);
    // TODO crooss out tasks that are done
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(widget.task.title),
        subtitle: timeToShortWidget(widget.task.time),
        leading: widget.task.isRunning
            ? IconButton(
                icon: Icon(
                  Icons.stop_outlined,
                  color: widget.task.priority.color,
                ),
                onPressed: _stop,
              )
            : IconButton(
                icon: Icon(
                  Icons.play_arrow_outlined,
                  color: widget.task.priority.color,
                ),
                onPressed: _start,
              ),
        trailing: IntrinsicWidth(
          child: Row(
            children: [
              if (widget.task.period.toOrder)
                const Text('#toOrder', style: TextStyle(color: Colors.orange)),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => widget.deleteTask(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
