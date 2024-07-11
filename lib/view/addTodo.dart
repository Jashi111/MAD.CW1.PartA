import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../controller/firebase_options.dart';
import '../controller/firebase_service.dart';
import '../model/fetchData.dart';

class AddTodo extends StatefulWidget {
  final Todo? todo;

  const AddTodo({Key? key, this.todo}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final taskBodyController = TextEditingController();
  final dueDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      taskBodyController.text = widget.todo!.taskBody;
      dueDateController.text = widget.todo!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Add ToDo",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: taskBodyController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 10.0),
                        ),
                        hintText: 'Task Body',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task body';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextFormField(
                      controller: dueDateController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'Due Date',
                        hintStyle: const TextStyle(color: Colors.white54),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.calendar_today,
                            color: Colors.white54,
                          ),
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                dueDateController.text = "${selectedDate.toLocal()}".split(' ')[0];
                              });
                            }
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a due date';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 1,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            try {
              if (widget.todo == null) {
                await addTodo(
                  title: titleController.text,
                  taskBody: taskBodyController.text,
                  dueDate: dueDateController.text,
                );
              } else {
                //String newTaskBody = taskBodyController.text;
                //String updatedTaskBody = "${widget.todo!.taskBody}\n$newTaskBody";
                await updateTodo(
                  id: widget.todo!.id,
                  title: titleController.text,
                  taskBody: taskBodyController.text,
                  dueDate: dueDateController.text,
                );
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ToDo saved successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
              titleController.clear();
              taskBodyController.clear();
              dueDateController.clear();
              Navigator.pop(context);
            } catch (e) {
              print('Error adding/updating data to Firestore: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error saving data. Please try again.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        },
        backgroundColor: Colors.teal,
        tooltip: widget.todo == null ? 'Save ToDo' : 'Update ToDo',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Icon(
          Icons.save,
          color: Colors.yellow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    taskBodyController.dispose();
    dueDateController.dispose();
    super.dispose();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.yellow,
      ),
      home: const AddTodo(),
    );
  }
}
