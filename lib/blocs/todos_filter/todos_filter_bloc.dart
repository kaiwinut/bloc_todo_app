import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_todo_app/models/todos_filter.dart';
import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../blocs.dart';

part 'todos_filter_event.dart';
part 'todos_filter_state.dart';

class TodosFilterBloc extends Bloc<TodosFilterEvent, TodosFilterState> {
  final TodosBloc _todosBloc;
  late StreamSubscription _todosStreamSubscription;

  TodosFilterBloc({required TodosBloc todosBloc})
      : _todosBloc = todosBloc,
        super(TodosFilterLoading()) {
    on<UpdateFilter>(_onUpdateFilter);
    on<UpdateTodos>(_onUpdateTodos);

    _todosStreamSubscription = _todosBloc.stream.listen((state) {
      add(
        const UpdateFilter(),
      );
    });
  }

  void _onUpdateFilter(UpdateFilter event, Emitter<TodosFilterState> emit) {
    if (state is TodosFilterLoading) {
      add(
        const UpdateTodos(todosFilter: TodosFilter.pending),
      );
    } else if (state is TodosFilterLoaded) {
      final state = this.state as TodosFilterLoaded;
      add(UpdateTodos(todosFilter: state.todosFilter));
    }
  }

  void _onUpdateTodos(UpdateTodos event, Emitter<TodosFilterState> emit) {
    final state = _todosBloc.state;
    if (state is TodosLoaded) {
      List<Todo> todos = state.todos.where((todo) {
        switch (event.todosFilter) {
          case TodosFilter.all:
            return true;
          case TodosFilter.completed:
            return todo.isCompleted!;
          case TodosFilter.cancelled:
            return todo.isCancelled!;
          case TodosFilter.pending:
            return !(todo.isCancelled! || todo.isCompleted!);
          default:
            return false;
        }
      }).toList();

      emit(
        TodosFilterLoaded(filteredTodos: todos, todosFilter: event.todosFilter),
      );
    }
  }
}
