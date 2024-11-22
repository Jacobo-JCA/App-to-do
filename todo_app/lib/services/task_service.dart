import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/data/task.dart';

class TaskService {
  final String baseUrl = 'http://localhost:5062/api/Task';

  Future<List<Task>> getAllTasks() async {
    final response = await http.get(Uri.parse('$baseUrl'));
    if (response.statusCode == 200) {
      final List<dynamic> taskJsonList = jsonDecode(response.body);
      return taskJsonList.map((taskJson) => Task.fromJson(taskJson)).toList();
    } else {
      throw Exception('Error al obtener las tareas: ${response.body}');
    }
  }

  Future<int> addTask(Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(taskData),
    );
    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      return responseBody['idTask'];
    } else {
      throw Exception('Error al crear la tarea: ${response.reasonPhrase}');
    }
  }

  Future<void> updateTaskTitle(int taskId, String newTitle) async {
    final url = Uri.parse('$baseUrl/$taskId/title');
    final body = jsonEncode(newTitle);
    await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
  }

  Future<void> markTaskAsCompleted(int taskId) async {
    final url = Uri.parse('$baseUrl/$taskId/complete');
    await http.put(url);
  }

  Future<void> deleteTask(int taskId) async {
    await http.delete(
      Uri.parse('$baseUrl/$taskId'),
    );
  }
}
