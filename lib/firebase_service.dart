import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class FirebaseService {
  final CollectionReference _tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  final String currentUserId = 'guest_user';

  Stream<List<Task>> getTasksStream(DateTime selectedDate) {
    final startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final endOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);
    return _tasksRef
       .where('userId', isEqualTo: currentUserId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addTask(String title, DateTime taskDate) async {
    final normalizedDate = DateTime(taskDate.year, taskDate.month, taskDate.day);
    await _tasksRef.add({
      'title': title,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
      'date': Timestamp.fromDate(normalizedDate),
      'userId': currentUserId,
    });
  }

  Future<void> toggleTaskStatus(String id, bool currentStatus) async {
    await _tasksRef.doc(id).update({'isCompleted': !currentStatus});
  }

  Future<void> deleteTask(String id) async {
  await _tasksRef.doc(id).delete();
}

  Future<void> updatetasksTitle(String id, String newTitle) async {
    await _tasksRef.doc(id).update({'title': newTitle});
  }

  Future<void> deletetasks(String id) async {
    await _tasksRef.doc(id).delete();
  }
}