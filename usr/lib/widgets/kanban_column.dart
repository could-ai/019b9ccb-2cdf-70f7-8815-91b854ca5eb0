import 'package:flutter/material.dart';
import '../models/task.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final Color color;
  final Function(Task, TaskStatus) onTaskMoved;
  final Function(Task) onTaskTap;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.tasks,
    required this.color,
    required this.onTaskMoved,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  tasks.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Draggable<Task>(
                  data: task,
                  feedback: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 32,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(task.title),
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: _buildTaskCard(task),
                  ),
                  child: DragTarget<Task>(
                    onAccept: (receivedTask) {
                      final newStatus = _getStatusFromTitle(title);
                      onTaskMoved(receivedTask, newStatus);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return _buildTaskCard(task);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getTypeColor(task.type),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    task.type.toString().split('.').last.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
                const Spacer(),
                if (task.assignee != null)
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey,
                    child: Text(
                      task.assignee!.initials,
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (task.dueDate != null) ...[
              const SizedBox(height: 4),
              Text(
                'Due: ${_formatDate(task.dueDate!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    ).gestures(onTap: () => onTaskTap(task));
  }

  TaskStatus _getStatusFromTitle(String title) {
    switch (title) {
      case 'To Do':
        return TaskStatus.toDo;
      case 'Processing':
        return TaskStatus.processing;
      case 'Completed':
        return TaskStatus.completed;
      default:
        return TaskStatus.toDo;
    }
  }

  Color _getTypeColor(TaskType type) {
    switch (type) {
      case TaskType.task:
        return const Color(0xFFf59e0b);
      case TaskType.decision:
        return const Color(0xFF10b981);
      case TaskType.promise:
        return const Color(0xFF8b5cf6);
      case TaskType.reminder:
        return const Color(0xFF0ea5e9);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

extension GestureExtension on Widget {
  Widget gestures({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
}