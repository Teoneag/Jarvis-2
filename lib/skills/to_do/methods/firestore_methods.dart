import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../global/device_id.dart';
import '../models/log_model.dart';
import '/skills/to_do/models/task_model.dart';

class FirestoreFields {
  static const String tasks = 'tasksTest8';
  static const String logs = 'logs';
}

class Firestore {
  static final _firestore = FirebaseFirestore.instance;

  static Future<List<Log>> getLogs() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreFields.logs)
          .doc(Device.getId())
          .collection(FirestoreFields.logs)
          .get();
      return querySnapshot.docs.map((doc) => Log.fromFirestore(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<void> addLog(Log log) async {
    try {
      await _firestore
          .collection(FirestoreFields.logs)
          .doc(Device.getId())
          .collection(FirestoreFields.logs)
          .doc(log.id)
          .set(log.toMap());
    } catch (e) {
      print(e);
    }
  }

  // TODO solve > 500 logs batch problem
  static Future<void> clearLogs() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreFields.logs)
          .doc(Device.getId())
          .collection(FirestoreFields.logs)
          .get();

      WriteBatch batch = _firestore.batch();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print("Error clearing logs: $e");
    }
  }

  static Future<String> addTask(Task task) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(FirestoreFields.tasks)
          .add(task.toFirestore());
      return docRef.id;
    } catch (e) {
      print(e);
      return '';
    }
  }

  static Future<String> addTaskWithId(Task task) async {
    try {
      DocumentReference docRef =
          _firestore.collection(FirestoreFields.tasks).doc(task.id);
      await docRef.set(task.toFirestore());
      return docRef.id;
    } catch (e) {
      print(e);
      return '';
    }
  }

  static Future<bool> updateTask(Task task) async {
    try {
      await _firestore
          .collection(FirestoreFields.tasks)
          .doc(task.id)
          .update(task.toFirestore());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection(FirestoreFields.tasks).doc(taskId).delete();
    } catch (e) {
      print(e);
    }
  }

  static Future<void> deleteSubTask(
      String parentTaskId, String subTaskId) async {
    try {
      await _firestore
          .collection(FirestoreFields.tasks)
          .doc(parentTaskId)
          .update({
        TaskFields.subTasks: FieldValue.arrayRemove([subTaskId])
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addSubTask(String parentTaskId, String subTaskId) async {
    try {
      await _firestore
          .collection(FirestoreFields.tasks)
          .doc(parentTaskId)
          .update({
        TaskFields.subTasks: FieldValue.arrayUnion([subTaskId])
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<void> reorderSubTask(
      String parentTaskId, List<String> subTasks) async {
    try {
      await _firestore
          .collection(FirestoreFields.tasks)
          .doc(parentTaskId)
          .update({TaskFields.subTasks: subTasks});
    } catch (e) {
      print(e);
    }
  }

  static Future<Task?> getTask(String taskId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection(FirestoreFields.tasks).doc(taskId).get();
      if (docSnapshot.exists) {
        return Task.fromFirestore(docSnapshot);
      } else {
        print('No task found with id $taskId');
        return null;
      }
    } catch (e) {
      print('Error getting task: $e');
      return null;
    }
  }

  static Future<List<Task>> getTasks() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(FirestoreFields.tasks)
          .where(TaskFields.isDone, isEqualTo: false)
          // .where(TaskFields.parentTaskId, isNull: true)
          .get();
      return querySnapshot.docs
          .map((doc) => Task.fromFirestore(doc))
          .where((task) =>
              task.parentTask == null || task.period.plannedStart != null)
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
