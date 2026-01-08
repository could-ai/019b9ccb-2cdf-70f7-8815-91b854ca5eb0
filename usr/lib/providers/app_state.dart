import 'package:flutter/material.dart';
import '../models/task.dart';

class AppState extends ChangeNotifier {
  bool _isAuthenticated = false;
  final List<Room> _rooms = [];
  final List<Task> _tasks = [];

  AppState() {
    _initializeDemoData();
  }

  bool get isAuthenticated => _isAuthenticated;
  List<Room> get rooms => _rooms;
  List<Task> get tasks => _tasks;

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  void updateTaskStatus(Task task, TaskStatus newStatus) {
    final index = _tasks.indexOf(task);
    if (index != -1) {
      _tasks[index] = task.copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void _initializeDemoData() {
    // Demo users
    final sarah = User(id: '1', name: 'Sarah Chen', email: 'sarah@example.com');
    final marcus = User(id: '2', name: 'Marcus Thompson', email: 'marcus@example.com');
    final jennifer = User(id: '3', name: 'Jennifer Wu', email: 'jennifer@example.com');
    final you = User(id: '4', name: 'You', email: 'you@example.com');

    // Demo room
    final room = Room(
      id: '1',
      name: 'Q1 Finance Review',
      icon: '💰',
      participants: [sarah, marcus, jennifer, you],
      messages: [
        Message(
          id: '1',
          sender: sarah,
          content: 'We are 15% over budget on infrastructure.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
          status: MessageStatus.read,
        ),
        Message(
          id: '2',
          sender: marcus,
          content: "I'll reach out to CloudServe for payment terms by Friday.",
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          status: MessageStatus.read,
        ),
        Message(
          id: '3',
          sender: you,
          content: "I'll call the bank tomorrow for credit options.",
          timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
          status: MessageStatus.delivered,
        ),
        Message(
          id: '4',
          sender: sarah,
          content: 'Agreed. We pursue negotiations before reallocation.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
          status: MessageStatus.sent,
        ),
      ],
    );
    _rooms.add(room);

    // Demo tasks
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Contact CloudServe for payment terms',
        type: TaskType.task,
        assignee: marcus,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        status: TaskStatus.toDo,
        context: marcus.messages.first.content,
        comments: [
          Comment(author: 'Marcus', content: 'Will start tomorrow', timestamp: DateTime.now()),
        ],
      ),
      Task(
        id: '2',
        title: 'Pursue negotiations before budget reallocation',
        type: TaskType.decision,
        status: TaskStatus.processing,
        context: sarah.messages.last.content,
        comments: [],
      ),
      Task(
        id: '3',
        title: 'Call bank for credit options',
        type: TaskType.promise,
        assignee: you,
        status: TaskStatus.toDo,
        context: you.messages.first.content,
        comments: [],
      ),
      Task(
        id: '4',
        title: 'Weekly budget monitoring - Fridays 2 PM',
        type: TaskType.reminder,
        status: TaskStatus.completed,
        comments: [],
      ),
    ]);
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  String get initials => name.split(' ').map((e) => e[0]).join().toUpperCase();
}

class Room {
  final String id;
  final String name;
  final String icon;
  final List<User> participants;
  final List<Message> messages;

  Room({required this.id, required this.name, required this.icon, required this.participants, required this.messages});
}

class Message {
  final String id;
  final User sender;
  final String content;
  final DateTime timestamp;
  final MessageStatus status;

  Message({required this.id, required this.sender, required this.content, required this.timestamp, required this.status});
}

enum MessageStatus { sent, delivered, read }

class Task {
  final String id;
  final String title;
  final TaskType type;
  final User? assignee;
  final DateTime? dueDate;
  final TaskStatus status;
  final String? context;
  final List<Comment> comments;

  Task({
    required this.id,
    required this.title,
    required this.type,
    this.assignee,
    this.dueDate,
    required this.status,
    this.context,
    required this.comments,
  });

  Task copyWith({TaskStatus? status}) {
    return Task(
      id: id,
      title: title,
      type: type,
      assignee: assignee,
      dueDate: dueDate,
      status: status ?? this.status,
      context: context,
      comments: comments,
    );
  }
}

enum TaskType { task, decision, promise, reminder }

enum TaskStatus { toDo, processing, completed }

class Comment {
  final String author;
  final String content;
  final DateTime timestamp;

  Comment({required this.author, required this.content, required this.timestamp});
}