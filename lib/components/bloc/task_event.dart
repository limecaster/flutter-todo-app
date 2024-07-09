part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class AddNewTaskEvent extends TaskEvent {
  final TaskModel taskModel;

  AddNewTaskEvent({required this.taskModel});
}

class FetchTaskEvent extends TaskEvent {}

class SortTaskEvent extends TaskEvent {
  final int sortOption;

  SortTaskEvent({required this.sortOption});
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel taskModel;

  UpdateTaskEvent({required this.taskModel});
}

class DeleteTaskEvent extends TaskEvent {
  final TaskModel taskModel;

  DeleteTaskEvent({required this.taskModel});
}

class SearchTaskEvent extends TaskEvent{
  final String keywords;

  SearchTaskEvent({required this.keywords});
}
