import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_list_app/models/to_do_model.dart';

class TodoProvider with ChangeNotifier {
  final String userId;
  List<TodoItem> _todos = [];

  TodoProvider(this.userId);

  List<TodoItem> get todos => _todos;

  // Firestore reference for the user's todo collection
  CollectionReference get _todoCollection =>
      FirebaseFirestore.instance.collection('users').doc(userId).collection('todos');

  // Fetch todos from Firestore
  Future<void> fetchTodos() async {
    try {
      final snapshot = await _todoCollection.get();
      _todos = snapshot.docs
          .map((doc) => TodoItem.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  // Add a new todo
  Future<void> addTodo(String title, VoidCallback onSuccess) async {
    try {
      final docRef = await _todoCollection.add({
        'title': title,
        'isCompleted': false,
      });
      _todos.add(TodoItem(id: docRef.id, title: title));
      notifyListeners();
      onSuccess();
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  // Update a todo's completion status
  Future<void> updateTodo(String id, bool isCompleted) async {
    try {
      await _todoCollection.doc(id).update({'isCompleted': isCompleted});
      final todo = _todos.firstWhere((todo) => todo.id == id);
      todo.isCompleted = isCompleted;
      notifyListeners();
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String id, VoidCallback onSuccess) async {
    try {
      await _todoCollection.doc(id).delete();
      _todos.removeWhere((todo) => todo.id == id);
      notifyListeners();
      onSuccess();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
  // Edit a todo's title
Future<void> editTodo(String id, String newTitle) async {
  try {
    // Update the Firestore document
    await _todoCollection.doc(id).update({'title': newTitle});

    // Find the index of the todo to be updated
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      // Update the local list
      _todos[index] = _todos[index].copyWith(title: newTitle);
      notifyListeners(); // Notify listeners to update the UI
    }
  } catch (e) {
    print('Error editing todo: $e');
  }
}


}
