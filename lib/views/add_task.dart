import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

// Local imports
import 'package:todo_list/components/bloc/task_bloc.dart';
import 'package:todo_list/components/build_text_field.dart';
import 'package:todo_list/data/models/task_model.dart';
import 'package:todo_list/utils/color_palette.dart';
import 'package:todo_list/utils/font_sizes.dart';
import 'package:todo_list/utils/build_text.dart';
import 'package:todo_list/utils/helpers.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController notes = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    _selectedDay = _focusedDay;
    super.initState();
  }

  _onRangeSelected(DateTime? start, DateTime? end, DateTime focusDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusDay;
      _rangeStart = start;
      _rangeEnd = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(children: [
            buildText('Create New Task', kBlackColor, textMedium,
                FontWeight.w500, TextAlign.start, TextOverflow.clip)
          ]),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocConsumer<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state is AddTaskSuccess) {
                  // Refresh the task list
                  context.read<TaskBloc>().add(FetchTaskEvent());
                  Navigator.of(context).pop();
                }
                if (state is AddTaskFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    getSnackBar(state.error, kRedColor)
                  );
                }
              },
              builder: (context, state) {
                return ListView(
                  children: [
                    TableCalendar(
                        calendarFormat: _calendarFormat,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month',
                          CalendarFormat.week: 'Week',
                        },
                        rangeSelectionMode: RangeSelectionMode.toggledOn,
                        focusedDay: _focusedDay,
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 1, 1),
                        onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        rangeStartDay: _rangeStart,
                        rangeEndDay: _rangeEnd,
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onRangeSelected: _onRangeSelected),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: buildText(
                          (_rangeStart != null && _rangeEnd != null)
                              ? 'Task starting at ${formatDate(dateTime: _rangeStart.toString())} - ${formatDate(dateTime: _rangeEnd.toString())}'
                              : 'Select Task Date',
                          kPrimaryColor,
                          textSmall,
                          FontWeight.w400,
                          TextAlign.start,
                          TextOverflow.clip),
                    ),
                    const SizedBox(height: 20),
                    buildText('Title', kBlackColor, textMedium, FontWeight.bold,
                        TextAlign.start, TextOverflow.clip),
                    const SizedBox(height: 10),
                    BuildTextField(
                        hint: 'Task Title',
                        inputType: TextInputType.text,
                        controller: title,
                        onChange: (value) {},
                        fillColor: kWhiteColor),
                    const SizedBox(height: 20),
                    buildText('Notes', kBlackColor, textMedium, FontWeight.bold,
                        TextAlign.start, TextOverflow.clip),
                    const SizedBox(height: 10),
                    BuildTextField(
                        hint: 'Task Notes',
                        inputType: TextInputType.text,
                        controller: notes,
                        onChange: (value) {},
                        fillColor: kWhiteColor),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final String taskId = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              var task = TaskModel(
                                  id: taskId,
                                  title: title.text,
                                  notes: notes.text,
                                  startDate: _rangeStart,
                                  dueDate: _rangeEnd,
                                  nguoiCapNhat: 'admin',
                                  ngayCapNhat: DateTime.now());
                              context.read<TaskBloc>().add(AddNewTaskEvent(taskModel: task));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: buildText(
                                    'Save',
                                    kWhiteColor,
                                    textMedium,
                                    FontWeight.bold,
                                    TextAlign.center,
                                    TextOverflow.clip)),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kGrey0,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: buildText(
                                    'Cancel',
                                    kWhiteColor,
                                    textMedium,
                                    FontWeight.bold,
                                    TextAlign.center,
                                    TextOverflow.clip)),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
