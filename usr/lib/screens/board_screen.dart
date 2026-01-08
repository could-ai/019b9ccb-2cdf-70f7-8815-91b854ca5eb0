import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/task.dart';
import '../widgets/kanban_column.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final filteredTasks = _selectedFilter == 'All'
        ? appState.tasks
        : appState.tasks.where((task) => task.type.toString().split('.').last == _selectedFilter.toLowerCase()).toList();

    final toDoTasks = filteredTasks.where((task) => task.status == TaskStatus.toDo).toList();
    final processingTasks = filteredTasks.where((task) => task.status == TaskStatus.processing).toList();
    final completedTasks = filteredTasks.where((task) => task.status == TaskStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Board'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: ['All', 'Task', 'Decision', 'Promise', 'Reminder']
                  .map((filter) => FilterChip(
                        label: Text(filter),
                        selected: _selectedFilter == filter,
                        onSelected: (selected) {
                          setState(() => _selectedFilter = selected ? filter : 'All');
                        },
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: KanbanColumn(
                    title: 'To Do',
                    tasks: toDoTasks,
                    color: const Color(0xFFf59e0b),
                    onTaskMoved: (task, newStatus) => appState.updateTaskStatus(task, newStatus),
                    onTaskTap: _showTaskDetail,
                  ),
                ),
                Expanded(
                  child: KanbanColumn(
                    title: 'Processing',
                    tasks: processingTasks,
                    color: const Color(0xFF10b981),
                    onTaskMoved: (task, newStatus) => appState.updateTaskStatus(task, newStatus),
                    onTaskTap: _showTaskDetail,
                  ),
                ),
                Expanded(
                  child: KanbanColumn(
                    title: 'Completed',
                    tasks: completedTasks,
                    color: const Color(0xFF8b5cf6),
                    onTaskMoved: (task, newStatus) => appState.updateTaskStatus(task, newStatus),
                    onTaskTap: _showTaskDetail,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskDetail(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(task.type),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      task.type.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                task.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Due: ${task.dueDate?.toString() ?? 'No due date'}'),
              const SizedBox(height: 16),
              const Text(
                'Original Context:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(task.context ?? 'No context available'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Comments:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView(
                  children: task.comments.map((comment) => ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(comment.author),
                        subtitle: Text(comment.content),
                        trailing: Text(comment.timestamp.toString()),
                      )).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}