import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:todo_app/services/task_service.dart';
import '../common/widgets/task_item.dart';
import '../common/styles/styles.dart';
import '../data/task.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  final TaskService _taskService = TaskService();
  bool _showGraph = false;

  int _completedCount = 0;
  int _incompletedCount = 0;
  int _deletedCount = 0;

  Future<void> _loadTasks() async {
    try {
      final tasks = await _taskService.getAllTasks();
      setState(() {
        _tasks.clear();
        _tasks.addAll(tasks);
      });
    } catch (e) {
      print('Error al cargar las tareas: $e');
    }
  }

  void _addTask(String title) async {
    if (title.isNotEmpty) {
      try {
        // Llamar al servicio para crear la tarea en la base de datos y obtener el `id`
        int id = await _taskService.addTask({
          'title': title,
          'isCompleted': false,
        });

        // Añadir la tarea localmente con el `id` recibido
        setState(() {
          final newTask = Task(id: id, title: title, isCompleted: false);
          _tasks.add(newTask);
          _incompletedCount++;
        });

        _controller.clear(); // Limpiar el campo de entrada
      } catch (e) {
        print('Error al agregar tarea: $e');
      }
    }
  }

  Future<void> _toggleCompleteTask(int id) async {
    try {
      // Llamar al servicio para marcar la tarea como completada
      await _taskService.markTaskAsCompleted(id);

      // Buscar la tarea en la lista local y actualizar su estado
      setState(() {
        final task = _tasks.firstWhere((task) => task.id == id);
        task.isCompleted = true; // Marca la tarea como completada
        _completedCount++; // Incrementa el contador de tareas completadas
        _incompletedCount--; // Disminuye el contador de tareas no completadas
      });
    } catch (e) {
      print('Error al marcar la tarea como completada: $e');
    }
  }

  Future<void> _updateTaskTitle(int taskId) async {
    final task = _tasks.firstWhere((task) => task.id == taskId);

    // Mostrar cuadro de diálogo para actualizar el título
    final newTitle = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController =
            TextEditingController(text: task.title);
        return AlertDialog(
          title: const Text('Editar título'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Nuevo título'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, titleController.text),
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );

    // Si el título no es vacío, actualizar la tarea
    if (newTitle != null && newTitle.isNotEmpty) {
      try {
        // Llamar al servicio para actualizar el título de la tarea
        await _taskService.updateTaskTitle(task.id, newTitle);

        setState(() {
          task.title = newTitle; // Actualiza el título localmente
        });
      } catch (e) {
        print('Error al actualizar título de la tarea: $e');
      }
    }
  }

  void _deleteTask(int taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      _loadTasks();
      _deletedCount--;
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            'To-Do App',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: AppStyles.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Text(
                'To-Do App',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            // Formulario para añadir tarea
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Añadir nueva tarea',
                        labelStyle: const TextStyle(color: Colors.black87),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(color: AppStyles.primaryColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add, color: AppStyles.primaryColor),
                    onPressed: () => _addTask(_controller.text),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Mostrar gráfico si _showGraph es true
            if (_showGraph)
              Center(
                // Centra el gráfico en la pantalla
                child: Container(
                  width: 300, // Tamaño ajustado
                  height: 250, // Tamaño ajustado
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          value: _completedCount.toDouble(),
                          title: 'Completadas\n$_completedCount',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          color: Colors.orange,
                          value: _incompletedCount.toDouble(),
                          title: 'No Completadas\n$_incompletedCount',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: _deletedCount.toDouble(),
                          title: 'Eliminadas\n$_deletedCount',
                          radius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            // Lista de tareas
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay tareas aún',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: FractionallySizedBox(
                            alignment: Alignment
                                .center, // Alinea el contenedor al centro
                            widthFactor:
                                0.6, // Esto ajusta el ancho al 60% del contenedor padre
                            child: Container(
                              decoration: AppStyles
                                  .taskContainerDecoration, // Aplicar estilo
                              child: TaskItem(
                                task: task,
                                onToggleComplete: _toggleCompleteTask,
                                onRemove: _deleteTask,
                                onEdit:
                                    _updateTaskTitle, // Aquí se pasa la función de edición
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showGraph = !_showGraph;
          });
        },
        backgroundColor: AppStyles.primaryColor,
        child: const Icon(Icons.show_chart),
      ),
    );
  }
}
