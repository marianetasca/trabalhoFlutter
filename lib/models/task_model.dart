class Task {
  String? title;
  String? description;
  bool? isDone;
  String? priority; // Adicionando o campo de prioridade

  Task({required this.title, required this.description, this.isDone = false, this.priority = 'Baixa'});

  Map toJson() {
    return {'title': title, 'description': description, 'isDone': isDone, 'priority': priority};// Salvando a prioridade
  }

  Task.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    isDone = json['isDone'] ?? false;
     priority = json['priority'] ?? 'Baixa'; // Recuperando a prioridade
  }
}