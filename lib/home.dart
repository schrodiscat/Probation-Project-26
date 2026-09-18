import 'package:flutter/material.dart';
import 'task_model.dart';
import 'firebase_service.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return StreamBuilder<List<Task>>(
      stream: firebaseService.getTasksStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final tasks = snapshot.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: const Text("Today's Tasks"),
          ),
          body: tasks.isEmpty
              ? const Center(
                  child: Text(
                    "No tasks for today! Tap + to add one.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) {
                          firebaseService.toggleTaskStatus(
                              task.id, task.isCompleted);
                        },
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showTaskModal(
                              context: context,
                              service: firebaseService,
                              taskToEdit: task,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => firebaseService.deleteTask(task.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showTaskModal(
              context: context,
              service: firebaseService,
            ),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showTaskModal({
    required BuildContext context,
    required FirebaseService service,
    Task? taskToEdit,
  }) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(
      text: taskToEdit != null ? taskToEdit.title : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                taskToEdit == null ? 'Add New Task' : 'Edit Task',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final text = controller.text.trim();
                    if (taskToEdit == null) {
                      service.addTask(text);
                    } else {
                      service.updateTaskTitle(taskToEdit.id, text);
                    }
                    Navigator.pop(ctx);
                  }
                },
                child: Text(taskToEdit == null ? 'Save Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}