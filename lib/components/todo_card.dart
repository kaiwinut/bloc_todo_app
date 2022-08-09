import 'package:bloc_todo_app/blocs/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/todo.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '#${todo.id}: ${todo.task}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<TodosBloc>().add(
                          UpdateTodo(
                            todo: todo.copyWith(isCompleted: true),
                          ),
                        );
                  },
                  icon: const Icon(Icons.add_task),
                ),
                IconButton(
                  onPressed: () {
                    context.read<TodosBloc>().add(
                          DeleteTodo(todo: todo),
                        );
                  },
                  icon: const Icon(Icons.cancel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
