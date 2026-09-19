import 'package:flutter/material.dart';
import 'task_model.dart';
import 'firebase_service.dart';
import 'progress_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return StreamBuilder<List<Task>>(
      stream: firebaseService.gettasksStream(),
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
        tasks.sort((a, b) {
        if (a.isCompleted == b.isCompleted) {
          return 0; 
         }
        return a.isCompleted ? 1 : -1;
         }
         );

        return Scaffold(
          appBar: AppBar(
            title: const Text("Today's Tasks"),
            actions: [
             IconButton(
               icon: const Icon(Icons.analytics_outlined),
               tooltip: "View Progress",
               onPressed: () {
                 Navigator.push(
                 context,
                 MaterialPageRoute(
                  builder: (_) => ProgressScreen(tasks: tasks),
                  ),
                 );
               },
              ),
            ],
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
                          firebaseService.toggletaskstatus(
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
                            onPressed: () => _showtasksModal(
                              context: context,
                              service: firebaseService,
                              tasksToEdit: task,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => firebaseService.deletetasks(task.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showtasksModal(
              context: context,
              service: firebaseService,
            ),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showtasksModal({
    required BuildContext context,
    required FirebaseService service,
    Task? tasksToEdit,
  }) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(
      text: tasksToEdit != null ? tasksToEdit.title : '',
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
                tasksToEdit == null ? 'Add New tasks' : 'Edit tasks',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'tasks Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid tasks title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final text = controller.text.trim();
                    if (tasksToEdit == null) {
                      service.addtasks(text);
                    } else {
                      service.updatetasksTitle(tasksToEdit.id, text);
                    }
                    Navigator.pop(ctx);
                  }
                },
                child: Text(tasksToEdit == null ? 'Save tasks' : 'Update tasks'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}