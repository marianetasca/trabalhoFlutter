import 'dart:convert';
import 'package:meuapp/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  Future<void> saveTask(String title, String description, String priority) async {
     if (title.isEmpty || description.isEmpty || priority.isEmpty) {
    throw Exception('Todos os campos devem ser preenchidos.');
  }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task newTask = Task(title: title, description: description, priority: priority);
    tasks.add(jsonEncode(newTask.toJson()));
    await prefs.setStringList('tasks', tasks);
    print('adicionado');
  }
  

  getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = prefs.getStringList('tasks') ?? [];
    if (taskStrings.isEmpty) {
    return <Task>[]; // Retorna uma lista vazia se não houver tarefas
  }
    List<Task> tasks = taskStrings
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
    return tasks;
  }

  deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    tasks.removeAt(index);
    await prefs.setStringList('tasks', tasks);
  }

  editTask(
      int index, String newTitle, String newDescription, bool isDone, String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task updateTask = Task(title: newTitle, description: newDescription, isDone: isDone, priority: priority);
    tasks[index] = jsonEncode(updateTask.toJson());
    await prefs.setStringList('tasks', tasks);
  }

  editTaskByCheckBox(int index, bool isDone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task existingTask = Task.fromJson(jsonDecode(tasks[index]));
    existingTask.isDone = isDone;
    tasks[index] = jsonEncode(existingTask.toJson());
    await prefs.setStringList('tasks', tasks);
    print('Editou isDone');
  }
}
