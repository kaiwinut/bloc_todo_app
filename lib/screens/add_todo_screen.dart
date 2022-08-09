import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';

class AddTodoScreen extends StatelessWidget {
  AddTodoScreen({Key? key}) : super(key: key);

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Pattern - Add A Todo'),
      ),
      body: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          if (state is TodosLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Todo added!'),
              ),
            );
          }
        },
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildInputField('ID', _idController),
              _buildInputField('Task', _taskController),
              _buildInputField('Description', _descriptionController),
              ElevatedButton(
                onPressed: () {
                  var todo = Todo(
                    id: _idController.text,
                    task: _taskController.text,
                    description: _descriptionController.text,
                  );
                  context.read<TodosBloc>().add(
                        AddTodo(todo: todo),
                      );
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                child: const Text('Add todo'),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildInputField(String field, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$field: ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.only(
            bottom: 10,
          ),
          width: double.infinity,
          child: TextFormField(
            controller: controller,
          ),
        ),
      ],
    );
  }
}
