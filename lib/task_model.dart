import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  String title;
  bool isCompleted;
  DateTime createdAt;
  DateTime date;
  String userId;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    required this.date,
    this.userId = 'guest_user',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt), 
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
      'userId': userId,
    };
  }

  factory Task.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      date: data['date'] != null
      ? (data['date'] as Timestamp).toDate()
      : DateTime.now(),
      userId: data['userId'] ?? 'guest_user',
    );
  }
}