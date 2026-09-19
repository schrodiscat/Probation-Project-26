import 'package:flutter/material.dart';
import 'task_model.dart';

class ProgressScreen extends StatelessWidget {
  final List<Task> tasks;

  const ProgressScreen({super.key, required this.tasks});

  
  double _getCompletionRateForDay(int weekdayIndex) {
    final dayTasks = tasks.where((t) => t.date.weekday == weekdayIndex).toList();
    if (dayTasks.isEmpty) return 0.0;

    final completedCount = dayTasks.where((t) => t.isCompleted).length;
    return completedCount / dayTasks.length;
  }

  @override
  Widget build(BuildContext context) {
  const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final currentTodayWeekday = DateTime.now().weekday; 

    const todayColor = Color(0xFF81C784); 
    const themeBlueColor = Color(0xFF64B5F6);
    return Scaffold(
      backgroundColor: const Color(0xFFB5D5E4), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF2F4F7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "WEEKLY INSIGHTS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your Insights",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Updated live from your task list",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 28),
                const Divider(height: 1, color: Color(0xFFF2F4F7)),
                const SizedBox(height: 24),

                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "This week",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.chevron_left, color: Colors.grey.shade700),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right, color: Colors.grey.shade700),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                
                SizedBox(
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                     final dayIndex = index + 1; 
                      final rate = _getCompletionRateForDay(dayIndex);
                      final isToday = dayIndex == currentTodayWeekday;
                      
                      
                      final barHeight = 20.0 + (rate * 120.0);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 28,
                            height: barHeight,
                            decoration: BoxDecoration(
                              color: isToday ? todayColor : themeBlueColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          Text(
                            days[index],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isToday ? Colors.black87 : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}