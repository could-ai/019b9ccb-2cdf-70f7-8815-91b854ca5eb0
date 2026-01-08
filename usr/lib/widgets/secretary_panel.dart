import 'package:flutter/material.dart';
import '../models/task.dart';

class SecretaryPanel extends StatefulWidget {
  final List<Task> tasks;
  final Function(Task) onTaskTap;

  const SecretaryPanel({
    super.key,
    required this.tasks,
    required this.onTaskTap,
  });

  @override
  State<SecretaryPanel> createState() => _SecretaryPanelState();
}

class _SecretaryPanelState extends State<SecretaryPanel> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFf4f7f9),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                const Text(
                  'Secretarial Insights',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_isCollapsed ? Icons.expand_more : Icons.expand_less),
                  onPressed: () => setState(() => _isCollapsed = !_isCollapsed),
                ),
              ],
            ),
          ),
          if (!_isCollapsed) ...[
            Expanded(
              child: ListView(
                children: _buildSections(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildSections() {
    final sections = [
      {'title': 'Tasks', 'type': TaskType.task, 'color': const Color(0xFFf59e0b)},
      {'title': 'Decisions', 'type': TaskType.decision, 'color': const Color(0xFF10b981)},
      {'title': 'Promises', 'type': TaskType.promise, 'color': const Color(0xFF8b5cf6)},
      {'title': 'Reminders', 'type': TaskType.reminder, 'color': const Color(0xFF0ea5e9)},
    ];

    return sections.map((section) {
      final tasks = widget.tasks.where((task) => task.type == section['type']).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              section['title'] as String,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ...tasks.map((task) => ListTile(
                leading: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: section['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(task.title),
                subtitle: task.assignee != null ? Text('Assigned to ${task.assignee!.name}') : null,
                onTap: () => widget.onTaskTap(task),
              )),
          if (tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('No items', style: TextStyle(color: Colors.grey)),
            ),
        ],
      );
    }).toList();
  }
}