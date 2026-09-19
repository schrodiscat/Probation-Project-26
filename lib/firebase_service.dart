import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class FirebaseService {
  final CollectionReference _tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  final String currentUserId = 'guest_user';

  Stream<List<Task>> gettasksStream() {
    return _tasksRef
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addtasks(String title) async {
    await _tasksRef.add({
      'title': title,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': currentUserId,
    });
  }

  Future<void> toggletaskstatus(String id, bool currentStatus) async {
    await _tasksRef.doc(id).update({'isCompleted': !currentStatus});
  }

  Future<void> updatetasksTitle(String id, String newTitle) async {
    await _tasksRef.doc(id).update({'title': newTitle});
  }

  Future<void> deletetasks(String id) async {
    await _tasksRef.doc(id).delete();
  }
}