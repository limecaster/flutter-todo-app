part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class FetchTasksSuccess extends TaskState {
  final List<TaskModel> tasks;
  final bool isSearching;

  FetchTasksSuccess({required this.tasks, this.isSearching = false});
}

final class AddTaskSuccess extends TaskState {}

final class LoadTaskFailure extends TaskState {
  final String error;

  LoadTaskFailure({required this.error});
}

final class AddTaskFailure extends TaskState {
  final String error;

  AddTaskFailure({required this.error});
}

final class TasksLoading extends TaskState {}

final class UpdateTaskFailure extends TaskState {
  final String error;

  UpdateTaskFailure({required this.error});
}

final class UpdateTaskSuccess extends TaskState {}

final class DeleteTaskFailure extends TaskState {
  final String error;

  DeleteTaskFailure({required this.error});
}

final class DeleteTaskSuccess extends TaskState {}

final class SearchTaskSuccess extends TaskState {
  final List<TaskModel> tasks;

  SearchTaskSuccess({required this.tasks});
}

final class SearchTaskFailure extends TaskState {
  final String error;

  SearchTaskFailure({required this.error});
}

final class SortTaskSuccess extends TaskState {
  final List<TaskModel> tasks;

  SortTaskSuccess({required this.tasks});
}

final class SortTaskFailure extends TaskState {
  final String error;

  SortTaskFailure({required this.error});
}



