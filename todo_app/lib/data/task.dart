class Task {
  final int id;
  String title;
  bool isCompleted;

  Task({required this.id, required this.title, this.isCompleted = false});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['idTask'],
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTask': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
