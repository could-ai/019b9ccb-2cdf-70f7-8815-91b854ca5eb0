import 'package:flutter/material.dart';
import '../models/room.dart';
import '../models/user.dart';

class Sidebar extends StatelessWidget {
  final List<Room> rooms;
  final Room currentRoom;
  final Function(Room) onRoomSelected;

  const Sidebar({
    super.key,
    required this.rooms,
    required this.currentRoom,
    required this.onRoomSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111827),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                final isSelected = room == currentRoom;
                return ListTile(
                  leading: Text(room.icon, style: const TextStyle(fontSize: 24)),
                  title: Text(
                    room.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    room.messages.isNotEmpty ? room.messages.last.content : 'No messages',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: room.messages.where((m) => m.status != MessageStatus.read).isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            room.messages.where((m) => m.status != MessageStatus.read).length.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        )
                      : null,
                  onTap: () => onRoomSelected(room),
                  tileColor: isSelected ? Colors.white.withOpacity(0.1) : null,
                );
              },
            ),
          ),
          const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'You',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'you@example.com',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}