import 'package:flutter/foundation.dart';
import '../data/todo_repository.dart';
import '../models/task.dart';

enum TaskFilter { all, active, done }

class TodoState extends ChangeNotifier {
  final TodoRepository _repo = TodoRepository();

  TaskFilter _filter = TaskFilter.all;
  String _query = '';
  String? _tagFilter; // null значит «все теги»

  TaskFilter get filter => _filter;
  String? get tagFilter => _tagFilter;

  List<Task> get visibleTasks {
    return _repo.getAll().where((t) {
      final matchFilter = switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.active => !t.isDone,
        TaskFilter.done => t.isDone,
      };
      final matchQuery = t.title.toLowerCase().contains(_query.toLowerCase());
      final matchTag = _tagFilter == null || t.tag == _tagFilter;
      return matchFilter && matchQuery && matchTag;
    }).toList();
  }

  void add(String title, String tag) {
    _repo.add(title.trim(), tag);
    notifyListeners();
  }

  void update(String id, String title, String tag) {
    _repo.update(id, title.trim(), tag);
    notifyListeners();
  }

  void toggleDone(String id) {
    _repo.toggleDone(id);
    notifyListeners();
  }

  void remove(String id) {
    _repo.remove(id);
    notifyListeners();
  }

  void setFilter(TaskFilter f) {
    _filter = f;
    notifyListeners();
  }

  void setQuery(String q) {
    _query = q;
    notifyListeners();
  }

  void setTagFilter(String? tag) {
    _tagFilter = tag;
    notifyListeners();
  }
}