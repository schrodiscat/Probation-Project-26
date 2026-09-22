import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class FirebaseService {
  final CollectionReference _tasksRef =
      FirebaseFirestore.instance.collection('tasks');

  
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  
  Future<void> addTask(String title, DateTime date) async {
    final cleanDate = _normalizeDate(date);
    await _tasksRef.add({
      'title': title,
      'isCompleted': false,
      'date': Timestamp.fromDate(cleanDate),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  
  Stream<List<Task>> getTasksStream(DateTime date) {
    final cleanDate = _normalizeDate(date);
    final startOfDay = Timestamp.fromDate(cleanDate);
    final endOfDay = Timestamp.fromDate(
      cleanDate.add(const Duration(days: 1)),
    );

    return _tasksRef
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .snapshots()
        .map((snapshot) {
         return snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
    });
  }

  
  Future<void> toggleTaskStatus(String id, bool currentStatus) async {
    await _tasksRef.doc(id).update({'isCompleted': !currentStatus});
  }


  Future<void> deleteTask(String id) async {
    await _tasksRef.doc(id).delete();
  }
}