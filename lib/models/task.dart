const List<String> kTags = ['Учёба', 'Работа', 'Дом', 'Другое'];

class Task {
  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;
  final String tag;

  const Task({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
    this.tag = 'Другое',
  });

  Task copyWith({String? title, bool? isDone, String? tag}) {
    return Task(
      id: id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
      tag: tag ?? this.tag,
    );
  }
}