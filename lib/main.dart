import 'package:flutter/material.dart';
import 'package:meuapp/views/List_views_tasks.dart';
import 'package:meuapp/views/form_tasks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 20, 95, 175)),
        useMaterial3: false,
      ),
      home: MyWidget(),
      routes: {
        '/ListarTarefas': (context) => ListViewsTasks(),
        '/criarTarefas': (context) => CreateTasks()
      },
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Minha lista de Tarefas'),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Mariane', style: TextStyle(fontSize: 24)),
                accountEmail: Text('mariane012.12@gmail.com'),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white, child: Icon(Icons.person)),
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('Lista de Tarefas'),
                onTap: () {
                  Navigator.pushNamed(context, '/ListarTarefas');
                },
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            Padding(padding: EdgeInsets.only(right: 20, bottom: 30, left: 10)),
            Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/criarTarefas');
                    },
                    child: Icon(Icons.add)))
          ],
        ));
  }
}
