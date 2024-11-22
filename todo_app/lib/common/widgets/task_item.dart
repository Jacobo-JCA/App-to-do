import 'package:flutter/material.dart';
import 'package:todo_app/data/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(int) onToggleComplete;
  final Function(int) onRemove;
  final Function(int) onEdit;

  const TaskItem({
    required this.task,
    required this.onToggleComplete,
    required this.onRemove,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          onToggleComplete(task.id);
        },
      ),
      title: Text(task.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono de editar
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              onEdit(task.id);
            },
          ),
          // Icono de eliminar
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              onRemove(task.id);
            },
          ),
        ],
      ),
    );
  }
}
