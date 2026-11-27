import 'package:flutter/material.dart';
import '../models/task.dart';
import '../state/todo_state.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TodoState _state = TodoState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year}';
  }

  Future<void> _showForm({Task? task}) async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (_) => TaskFormDialog(task: task),
    );
    if (result == null) return;
    final (title, tag) = result;
    if (task == null) {
      _state.add(title, tag);
    } else {
      _state.update(task.id, title, tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mutedColor = Theme.of(context).colorScheme.outline;

    return Scaffold(
      appBar: AppBar(title: const Text('Список задач')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: _state,
        builder: (context, _) {
          final tasks = _state.visibleTasks;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  onChanged: _state.setQuery,
                  decoration: const InputDecoration(
                    hintText: 'Поиск по названию',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SegmentedButton<TaskFilter>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: TaskFilter.all, label: Text('Все')),
                    ButtonSegment(
                        value: TaskFilter.active, label: Text('Активные')),
                    ButtonSegment(
                        value: TaskFilter.done, label: Text('Выполненные')),
                  ],
                  selected: {_state.filter},
                  onSelectionChanged: (s) => _state.setFilter(s.first),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    for (final t in [null, ...kTags])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(t ?? 'Все теги'),
                          selected: _state.tagFilter == t,
                          onSelected: (_) => _state.setTagFilter(t),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(child: Text('Задач нет'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: tasks.length,
                        itemBuilder: (context, i) {
                          final t = tasks[i];
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 8, right: 4),
                            leading: Checkbox(
                              value: t.isDone,
                              onChanged: (_) => _state.toggleDone(t.id),
                            ),
                            title: Text(
                              t.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                decoration:
                                    t.isDone ? TextDecoration.lineThrough : null,
                                color: t.isDone ? mutedColor : null,
                              ),
                            ),
                            subtitle: Text(
                              '${t.tag} · ${_formatDate(t.createdAt)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () => _showForm(task: t),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showForm(task: t),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _state.remove(t.id),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TaskFormDialog extends StatefulWidget {
  final Task? task;
  const TaskFormDialog({super.key, this.task});

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  late String _tag;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task?.title ?? '');
    _tag = widget.task?.tag ?? kTags.last;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(),
      backgroundColor: const Color(0xFFFFFAEA),
      surfaceTintColor: Colors.transparent,
      title: Text(widget.task == null ? 'Новая задача' : 'Редактирование'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Название'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите название задачи';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tag,
              isExpanded: true,
              dropdownColor: const Color(0xFFFFFAEA),
              borderRadius: BorderRadius.zero,
              decoration: const InputDecoration(labelText: 'Тег'),
              items: [
                for (final t in kTags)
                  DropdownMenuItem(value: t, child: Text(t)),
              ],
              onChanged: (v) => setState(() => _tag = v ?? _tag),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(context, (_controller.text, _tag));
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
