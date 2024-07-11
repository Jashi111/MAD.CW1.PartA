import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/fetchData.dart';

Future<void> addTodo({
  required String title,
  required String taskBody,
  required String dueDate,
}) async {
  CollectionReference todoRef = FirebaseFirestore.instance.collection('ToDo');

  await todoRef.add({
    'tite': title,
    'taskBody': taskBody,
    'dueDate': dueDate,
  });
}

Stream<List<Todo>> getTodos() {
  return FirebaseFirestore.instance.collection('ToDo').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      // Log the document data
      print('Fetched document data: ${doc.data()}');
      return Todo.fromDocument(doc);
    }).toList();
  });
}

Future<void> deleteTodoById(String id) async {
  DocumentSnapshot doc = await FirebaseFirestore.instance.collection('ToDo').doc(id).get();
  print('Deleted data: ${doc.data()}');
  await FirebaseFirestore.instance.collection('ToDo').doc(id).delete();
}

Future<void> updateTodo({
  required String id,
  required String title,
  required String taskBody,
  required String dueDate,
}) async {
  final todo = {
    'title': title,
    'taskBody': taskBody,
    'dueDate': dueDate,
  };

  await FirebaseFirestore.instance.collection('ToDo').doc(id).update(todo);
}

List<Todo> searchTodos(List<Todo> todos, String query) {
  final searchLower = query.toLowerCase();

  return todos.where((todo) {
    final titleLower = todo.title.toLowerCase();
    final bodyLower = todo.taskBody.toLowerCase();
    final duoDateLower = todo.dueDate.toLowerCase();
    return titleLower.contains(searchLower) || bodyLower.contains(searchLower);
  }).toList();
}