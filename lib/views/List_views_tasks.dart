import 'package:flutter/material.dart';
import 'package:meuapp/models/task_model.dart';
import 'package:meuapp/services/task_service.dart';
import 'package:meuapp/views/form_tasks.dart';

class ListViewsTasks extends StatefulWidget {
  const ListViewsTasks({super.key});

  @override
  State<ListViewsTasks> createState() => _ListViewsTasksState();
}

class _ListViewsTasksState extends State<ListViewsTasks> {
  TaskService taskService = TaskService();
  List<Task> tasks = [];

  getAllTasks() async {
    tasks = await taskService.getTasks();
    setState(() {});
  }

  @override
  void initState() {
    getAllTasks();
    super.initState();
  }

  // Função para retornar a cor do texto baseado na prioridade
  Color getPriorityTextColor(String? priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red; // Cor vermelha para prioridade Alta
      case 'Média':
        return Colors.orange; // Cor laranja para prioridade Média
      case 'Baixa':
      default:
        return Colors.green; // Cor verde para prioridade Baixa
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Tarefas')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          bool localIsDone = tasks[index].isDone ?? false;
          return Column(
            children: [
              Card(
                color: const Color.fromARGB(198, 233, 233, 233),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinhar conteúdo do card
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // Alinhamento
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tasks[index].title.toString(),
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: localIsDone
                                      ? Colors.green
                                      : Color.fromARGB(255, 83, 129, 215),
                                  decoration: localIsDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration
                                          .none, // Linha para tarefa concluída
                                ),
                              ),
                              SizedBox(height: 5),
                              // Descrição da tarefa
                              Text(
                                tasks[index].description.toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black87),
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RichText(
                                text: TextSpan(
                                  text: 'Prioridade: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: getPriorityTextColor(
                                        tasks[index].priority),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: tasks[index]
                                          .priority!, // Exibe apenas o texto da prioridade
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: getPriorityTextColor(tasks[index]
                                            .priority), // Cor baseada na prioridade
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                ],
                              )
                              
                            ],
                          ),
                          Checkbox(
                            value: tasks[index].isDone ?? false,
                            onChanged: (value) async {
                              if (value != null) {
                                await taskService.editTask(
                                  index,
                                  tasks[index].title!,
                                  tasks[index].description!,
                                  value, // Altera o status da tarefa
                                  tasks[index]
                                      .priority!, // Mantém a prioridade ao editar
                                );
                                setState(() {
                                  tasks[index].isDone = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: localIsDone
                                ? null // Desativa o botão se a tarefa estiver concluída
                                : () async {
                                    await taskService.deleteTask(index);
                                    getAllTasks();
                                  },
                            icon: const Icon(Icons.delete),
                            color: localIsDone
                                ? Colors.grey
                                : Colors
                                    .red, // Altera a cor para cinza se concluída
                          ),
                          if (!localIsDone) // Esconde o ícone de editar se a tarefa estiver concluída
                            IconButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateTasks(
                                        task: tasks[index], index: index),
                                  ),
                                ).then((value) => getAllTasks());
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
