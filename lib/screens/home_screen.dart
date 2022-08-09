import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../components/components.dart';
import '../models/models.dart';
import 'screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BLoC Pattern - Todos'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddTodoScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add))
          ],
          bottom: TabBar(
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.read<TodosFilterBloc>().add(
                          const UpdateTodos(todosFilter: TodosFilter.pending),
                        );
                    break;
                  case 1:
                    context.read<TodosFilterBloc>().add(
                          const UpdateTodos(todosFilter: TodosFilter.completed),
                        );
                    break;
                }
              },
              tabs: const [
                Tab(
                  icon: Icon(Icons.pending),
                ),
                Tab(
                  icon: Icon(Icons.add_task),
                )
              ]),
        ),
        body: TabBarView(
          children: [
            _buildBody('Pending Todos'),
            _buildBody('Completed Todos'),
          ],
        ),
      ),
    );
  }

  BlocConsumer<TodosFilterBloc, TodosFilterState> _buildBody(String title) {
    return BlocConsumer<TodosFilterBloc, TodosFilterState>(
      listener: ((context, state) {
        if (state is TodosFilterLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'There are ${state.filteredTodos.length} todo(s) in the ${state.todosFilter.toString().split(".").last} list.'),
            ),
          );
        }
      }),
      builder: (context, state) {
        if (state is TodosFilterLoading) {
          return const CircularProgressIndicator();
        } else if (state is TodosFilterLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$title: ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.filteredTodos.length,
                  itemBuilder: ((context, index) =>
                      TodoCard(todo: state.filteredTodos[index])),
                )
              ],
            ),
          );
        }
        return const Text('Something went wrong');
      },
    );
  }
}
