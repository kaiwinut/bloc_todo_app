import '../blocs/blocs.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/models.dart';
import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosBloc()
            ..add(
              LoadTodos(todos: Todo.examples),
            ),
        ),
        BlocProvider(
          create: (context) => TodosFilterBloc(
            todosBloc: context.read<TodosBloc>(),
          ),
        )
      ],
      child: MaterialApp(
        title: 'BLoC Pattern - Todo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xff000a1f),
          appBarTheme: const AppBarTheme(
            color: Color(0xff000a1f),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
