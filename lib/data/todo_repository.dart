import '../models/task.dart';

class TodoRepository {
  final List<Task> _tasks = [];

  List<Task> getAll() => List.unmodifiable(_tasks);

  void add(String title, String tag) {
    _tasks.add(Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      tag: tag,
    ));
  }

  void update(String id, String newTitle, String tag) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i != -1) _tasks[i] = _tasks[i].copyWith(title: newTitle, tag: tag);
  }

  void toggleDone(String id) {
    final i = _tasks.indexWhere((t) => t.id == id);
    if (i != -1) _tasks[i] = _tasks[i].copyWith(isDone: !_tasks[i].isDone);
  }

  void remove(String id) => _tasks.removeWhere((t) => t.id == id);
}