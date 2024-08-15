import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../global/device_id.dart';
import '../enums/action_enum.dart';

class LogFields {
  static const String id = 'id';
  static const String action = 'action';
  static const String taskId = 'taskId';
}

class Log {
  String id;
  Action action;
  String taskId;

  Log(
    this.action,
    this.taskId, {
    id,
  }) : id = id ?? DateTime.now().toString() + Device.getId();

  factory Log.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    return Log.fromMap(data, doc.id);
  }

  factory Log.fromMap(Map<String, dynamic> data, String id) {
    return Log(
      id: id,
      Action.values[data[LogFields.action]],
      data[LogFields.taskId],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      LogFields.action: action.index,
      LogFields.taskId: taskId,
    };
  }
}
