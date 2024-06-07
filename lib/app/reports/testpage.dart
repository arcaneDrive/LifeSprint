import 'package:flutter/material.dart';
import 'package:last_minute_driver/app/reports/database_service.dart';

import 'models.dart';

class Testpage extends StatefulWidget {
  const Testpage({super.key});

  @override
  State<Testpage> createState() => _TestpageState();
}

class _TestpageState extends State<Testpage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  String? _task = null;

  Widget _addTaskbutton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text("add task"),
                  content: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _task = value;
                          });
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Subcribe...'),
                      ),
                      MaterialButton(
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          if (_task == null || _task == "") return;
                          _databaseService.addTask(_task!);
                          setState(() {
                            _task = null;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ));
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _tasksList() {
    return FutureBuilder(
        future: _databaseService.getTask(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              Task task = snapshot.data![index];
              return ListTile(
                onLongPress: () {
                  _databaseService.deleteTask(
                    task.id,
                  );
                  setState(() {});
                },
                title: Text(task.content),
                trailing: Checkbox(
                  value: task.status == 1,
                  onChanged: (value) {
                    _databaseService.updateTaskStatus(
                      task.id,
                      value == true ? 1 : 0,
                    );
                    setState(() {});
                  },
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addTaskbutton(),
      body: _tasksList(),
    );
  }
}
