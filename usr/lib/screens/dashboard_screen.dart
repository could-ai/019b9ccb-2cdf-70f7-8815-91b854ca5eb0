import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/room.dart';
import '../models/message.dart';
import '../models/task.dart';
import '../widgets/sidebar.dart';
import '../widgets/chat_area.dart';
import '../widgets/secretary_panel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Room _currentRoom;

  @override
  void initState() {
    super.initState();
    _currentRoom = context.read<AppState>().rooms.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RiteHand Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () => Navigator.pushNamed(context, '/board'),
          ),
        ],
      ),
      body: isDesktop
          ? Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Sidebar(
                    rooms: appState.rooms,
                    currentRoom: _currentRoom,
                    onRoomSelected: (room) => setState(() => _currentRoom = room),
                  ),
                ),
                Expanded(
                  child: ChatArea(messages: _currentRoom.messages),
                ),
                SizedBox(
                  width: 350,
                  child: SecretaryPanel(
                    tasks: appState.tasks,
                    onTaskTap: (task) {
                      // Scroll to message
                      // For now, show snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Scroll to message: ${task.title}')),
                      );
                    },
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: ChatArea(messages: _currentRoom.messages),
                ),
                SizedBox(
                  height: 300,
                  child: SecretaryPanel(
                    tasks: appState.tasks,
                    onTaskTap: (task) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Scroll to message: ${task.title}')),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}