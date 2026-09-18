import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class FirebaseService {
  final CollectionReference _tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  final String currentUserId = 'guest_user';

  Stream<List<Task>> getTasksStream() {
    return _tasksRef
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addTask(String title) async {
    await _tasksRef.add({
      'title': title,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });
  }

  Future<void> toggleTaskStatus(String id, bool currentStatus) async {
    await _tasksRef.doc(id).update({'isCompleted': !currentStatus});
  }

  Future<void> updateTaskTitle(String id, String newTitle) async {
    await _tasksRef.doc(id).update({'title': newTitle});
  }

  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }
}