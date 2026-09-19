import 'package:flutter/material.dart';
import 'task_model.dart';

class ProgressScreen extends StatelessWidget {
  final List<Task> tasks;

  const ProgressScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final int totalCount = tasks.length;
    final int completedCount = tasks.where((t) => t.isCompleted).length;
    final double percentage =
        totalCount == 0 ? 0.0 : (completedCount / totalCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Overview'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 14,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
                    ),
                  ),
                  Text(
                    '${(percentage * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              
              Text(
                '$completedCount of $totalCount tasks completed',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
             
              Text(
                totalCount == 0
                    ? "No tasks found! Add some tasks to track progress."
                    : percentage == 1.0
                        ? "Amazing! All tasks completed! 🎉"
                        : "Keep going, you're making progress!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}