import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_list/components/bloc/task_bloc.dart';

import 'package:todo_list/data/models/task_model.dart';
import 'package:todo_list/utils/build_text.dart';
import 'package:todo_list/utils/color_palette.dart';
import 'package:todo_list/utils/font_sizes.dart';
import 'package:todo_list/utils/helpers.dart';
import 'package:todo_list/views/update_task.dart';

class TaskItem extends StatefulWidget {
  final TaskModel taskModel;
  const TaskItem({super.key, required this.taskModel});

  @override
  // ignore: library_private_types_in_public_api
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
                value: widget.taskModel.isDone,
                onChanged: (value) {
                  var taskModel = TaskModel(
                    id: widget.taskModel.id,
                    title: widget.taskModel.title,
                    notes: widget.taskModel.notes,
                    priority: widget.taskModel.priority,
                    isImportance: widget.taskModel.isImportance,
                    isStarred: widget.taskModel.isStarred,
                    isDone: !widget.taskModel.isDone,
                    startDate: widget.taskModel.startDate,
                    dueDate: widget.taskModel.dueDate,
                  );
                  context
                      .read<TaskBloc>()
                      .add(UpdateTaskEvent(taskModel: taskModel));
                }),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: buildText(
                        widget.taskModel.title,
                        kBlackColor,
                        textMedium,
                        FontWeight.w500,
                        TextAlign.start,
                        TextOverflow.clip,
                      )),
                      PopupMenuButton<int>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: kWhiteColor,
                        elevation: 1,
                        onSelected: (value) {
                          switch (value) {
                            case 1:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateTaskScreen(
                                      taskModel: widget.taskModel),
                                ),
                              );
                              break;
                            case 2:
                              context.read<TaskBloc>().add(
                                  DeleteTaskEvent(taskModel: widget.taskModel));
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/edit.svg',
                                  width: 20,
                                ),
                                const SizedBox(width: 10),
                                buildText(
                                  'Edit',
                                  kBlackColor,
                                  textMedium,
                                  FontWeight.normal,
                                  TextAlign.start,
                                  TextOverflow.clip,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/delete.svg',
                                  width: 18,
                                ),
                                const SizedBox(width: 10),
                                buildText(
                                  'Delete',
                                  kBlackColor,
                                  textMedium,
                                  FontWeight.normal,
                                  TextAlign.start,
                                  TextOverflow.clip,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  buildText(
                    widget.taskModel.notes ?? 'No description',
                    kGrey1,
                    textSmall,
                    FontWeight.normal,
                    TextAlign.start,
                    TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svgs/calendar.svg',
                              width: 12),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildText(
                                '${formatDate(dateTime: widget.taskModel.startDate.toString())} - ${formatDate(dateTime: widget.taskModel.dueDate.toString())}',
                                kBlackColor,
                                textTiny,
                                FontWeight.w400,
                                TextAlign.start,
                                TextOverflow.clip),
                          )
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(width: 5),
          ],
        ));
  }
}
