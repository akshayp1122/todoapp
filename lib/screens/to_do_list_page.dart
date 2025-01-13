import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/controller/to_do_provider.dart';
import 'package:todo_list_app/screens/login_screen.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch todos when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).fetchTodos();
    });
  }

  // Function to handle logout
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase logout
      // Navigate to the login page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent, // Main background color
        elevation: 10, // Shadow effect
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),

        title: const Text(
          'To-Do List',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white, // Text color
          ),
        ),
        centerTitle: true, // Centers the title
        actions: [
          SizedBox(
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ),
        ],
      ),
      body: Consumer<TodoProvider>(builder: (context, todoProvider, child) {
        return Column(
          children: [
            Expanded(
              child: todoProvider.todos.isEmpty
                  ? const Center(child: Text('No tasks found!'))
                  : ListView.builder(
                      itemCount: todoProvider.todos.length,
                      itemBuilder: (context, index) {
                        final todo = todoProvider.todos[index];
                        return Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue,
                                  Colors.purple,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left-aligned content
                                  Expanded(
                                    child: Text(
                                      todo.title,
                                      style: TextStyle(
                                        fontSize: todo.isCompleted ? 20 : 20,
                                        fontWeight: todo.isCompleted
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                        decoration: todo.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _editTodoDialog(
                                          context, todo.id, todo.title);
                                    },
                                  ),

                                  // Existing trailing content (replace with your content)
                                  Checkbox(
                                    value: todo.isCompleted,
                                    activeColor: todo.isCompleted
                                        ? Colors.green
                                        : Colors.black,
                                    onChanged: (value) {
                                      todoProvider.updateTodo(todo.id, value!);
                                    },
                                  ),

                                  // Delete button
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      todoProvider.deleteTodo(
                                        todo.id,
                                        () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Task successfully deleted'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, right: 14.0, bottom: 30.0, top: 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a new task',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent),
                    onPressed: () {
                      if (_todoController.text.isNotEmpty) {
                        todoProvider.addTodo(
                          _todoController.text,
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task successfully added'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        );
                        _todoController.clear();
                      }
                    },
                    child: const Text('Add',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

void _editTodoDialog(BuildContext context, String todoId, String currentTitle) {
  final _editController = TextEditingController(text: currentTitle);

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Edit Todo'),
        content: TextField(
          controller: _editController,
          decoration: const InputDecoration(hintText: 'Enter new title'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final newTitle = _editController.text.trim();
              if (newTitle.isNotEmpty) {
                // Access the provider using dialog context
                final todoProvider =
                    Provider.of<TodoProvider>(context, listen: false);

                await todoProvider.editTodo(todoId, newTitle);

                Navigator.pop(dialogContext); // Close dialog
              }
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}
