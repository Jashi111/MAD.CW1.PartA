import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final String taskBody;
  final String dueDate;

  Todo({
    required this.id,
    required this.title,
    required this.taskBody,
    required this.dueDate,
  });

  factory Todo.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    print('Mapping document to Todo: $data');
    return Todo(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      taskBody: data['taskBody'] ?? 'No Task Body',
      dueDate: data['dueDate'] ?? 'No Due Date',
    );
  }
}