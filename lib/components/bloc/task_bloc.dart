import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/data/models/task_model.dart';
import 'package:todo_list/data/repositories/task_repository.dart';
import 'package:flutter/foundation.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc(this.taskRepository) : super(FetchTasksSuccess(tasks: const [])) {
    on<AddNewTaskEvent>(_addNewTask);
    on<FetchTaskEvent>(_fetchTasks);
    on<UpdateTaskEvent>(_updateTask);
    on<DeleteTaskEvent>(_deleteTask);
    on<SortTaskEvent>(_sortTasks);
    on<SearchTaskEvent>(_searchTasks);
  }

  _addNewTask(AddNewTaskEvent event, Emitter<TaskState> emit) async {
    emit(TasksLoading());
    try {
      if (event.taskModel.title.trim().isEmpty) {
        return emit(AddTaskFailure(error: 'Task title cannot be blank'));
      }
      if (event.taskModel.notes!.trim().isEmpty) {
        return emit(AddTaskFailure(error: 'Task notes cannot be blank'));
      }
      if (event.taskModel.startDate == null) {
        return emit(AddTaskFailure(error: 'Missing task start date'));
      }
      if (event.taskModel.dueDate == null) {
        return emit(AddTaskFailure(error: 'Missing task stop date'));
      }
      await taskRepository.createNewTask(event.taskModel);
      emit(AddTaskSuccess());
      final tasks = await taskRepository.getTasks();
      return emit(FetchTasksSuccess(tasks: tasks));
    } catch (exception) {
      emit(AddTaskFailure(error: exception.toString()));
    }
  }

  void _fetchTasks(FetchTaskEvent event, Emitter<TaskState> emit) async {
    emit(TasksLoading());
    try {
      final tasks = await taskRepository.getTasks();
      return emit(FetchTasksSuccess(tasks: tasks));
    } catch (exception) {
      emit(LoadTaskFailure(error: exception.toString()));
    }
  }

  _updateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      if (event.taskModel.title.trim().isEmpty) {
        return emit(UpdateTaskFailure(error: 'Task title cannot be blank'));
      }
      if (event.taskModel.notes!.trim().isEmpty) {
        return emit(UpdateTaskFailure(error: 'Task notes cannot be blank'));
      }
      if (event.taskModel.startDate == null) {
        return emit(UpdateTaskFailure(error: 'Missing task start date'));
      }
      if (event.taskModel.dueDate == null) {
        return emit(UpdateTaskFailure(error: 'Missing task stop date'));
      }
      await taskRepository.updateTask(event.taskModel);
      emit(UpdateTaskSuccess());
      final tasks = await taskRepository.getTasks();
      return emit(FetchTasksSuccess(tasks: tasks));
    } catch (exception) {
      emit(UpdateTaskFailure(error: exception.toString()));
    }
  }

  _deleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      await taskRepository.deleteTask(event.taskModel);
      final tasks = await taskRepository.getTasks();
      return emit(FetchTasksSuccess(tasks: tasks));
    } catch (exception) {
      emit(LoadTaskFailure(error: exception.toString()));
    }
  }

  _sortTasks(SortTaskEvent event, Emitter<TaskState> emit) async {
    final tasks = await taskRepository.sortTasks(event.sortOption);
    emit(FetchTasksSuccess(tasks: tasks));
  }

  _searchTasks(SearchTaskEvent event, Emitter<TaskState> emit) async {
    final tasks = await taskRepository.searchTasks(event.keywords);
    emit(FetchTasksSuccess(tasks: tasks));
  }
}
