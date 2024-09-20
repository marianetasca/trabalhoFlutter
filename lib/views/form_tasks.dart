import 'package:flutter/material.dart';
import 'package:meuapp/models/task_model.dart';
import 'package:meuapp/services/task_service.dart';

class CreateTasks extends StatefulWidget {
  final Task? task;
  final int? index;
  const CreateTasks({super.key, this.task, this.index});

  @override
  State<CreateTasks> createState() => _CreateTasksState();
}

class _CreateTasksState extends State<CreateTasks> {
  final _formKey = GlobalKey<FormState>();
  final TaskService taskService = TaskService();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  // Variável para armazenar a prioridade da tarefa, inicializada como "Baixa"
  String _selectedPriority = 'Baixa';

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title!;
      _descriptionController.text = widget.task!.description!;
      _selectedPriority =
          widget.task?.priority ?? 'Baixa'; // Defina a prioridade selecionada
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null
            ? 'Editar tarefa'
            : 'Criar nova tarefa'), // Título dinâmico
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, //espaçamento
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '*Título não preenchido!';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Título da tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '* Descrição não preenchida!';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Descrição da tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            // Adicionando os Radios para prioridade
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Prioridade:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height:
                          10), // Espaço entre o texto "Prioridade" e as opções
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Baixa',
                            groupValue: _selectedPriority,
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value!;
                              });
                            },
                          ),
                          Text('Baixa'),
                        ],
                      ),
                      SizedBox(
                          width: 20), // Espaçamento horizontal entre as opções
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Média',
                            groupValue: _selectedPriority,
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value!;
                              });
                            },
                          ),
                          const Text('Média'),
                        ],
                      ),
                      SizedBox(
                          width: 20), // Espaçamento horizontal entre as opções
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Alta',
                            groupValue: _selectedPriority,
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value!;
                              });
                            },
                          ),
                          Text('Alta'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
                height:
                    20), // Espaçamento entre a seção de prioridade e o botão
            Padding(
                padding: EdgeInsets.all(5),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String newTitle = _titleController.text;
                        String newDescription = _descriptionController.text;

                        try {
                          if (widget.task != null && widget.index != null) {
                            await taskService.editTask(
                              widget.index!,
                              newTitle,
                              newDescription,
                              false,
                              _selectedPriority, // Salvando a prioridade selecionada
                            );
                          } else {
                            await taskService.saveTask(
                              newTitle,
                              newDescription,
                              _selectedPriority, // Salvar com a prioridade
                            );
                          }
                          Navigator.pop(context);
                        } catch (e) {
                          // Exibir um alerta ou Snackbar com a mensagem de erro
                          print('Erro ao salvar a tarefa: $e');
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Erro ao salvar a tarefa: $e')));
                        }
                      }
                    },
                    child: Text(widget.task != null
                        ? 'Alterar tarefa'
                        : 'Salvar tarefa'), // Texto dinâmico do botão
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
