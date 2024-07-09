// Library imports
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_list/components/bloc/task_bloc.dart';
import 'package:todo_list/components/task_item.dart';
import 'package:todo_list/routes/screens.dart';
import 'package:todo_list/utils/build_text.dart';

// Local imports
import 'package:todo_list/utils/color_palette.dart';
import 'package:todo_list/components/build_text_field.dart';
import 'package:todo_list/utils/font_sizes.dart';
import 'package:todo_list/utils/helpers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    context.read<TaskBloc>().add(FetchTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: ScaffoldMessenger(
        child: Scaffold(
            backgroundColor: kWhiteColor,
            appBar: AppBar(
              backgroundColor: kWhiteColor,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: buildText('Todo List', kBlackColor, textMedium,
                  FontWeight.w500, TextAlign.start, TextOverflow.clip),
              flexibleSpace: Container(
                color:
                    kWhiteColor, // Make sure that appbar's color is not changed when scrolling
              ),
              actions: [
                PopupMenuButton<int>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 1,
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        context
                            .read<TaskBloc>()
                            .add(SortTaskEvent(sortOption: 0));
                        break;
                      case 1:
                        context
                            .read<TaskBloc>()
                            .add(SortTaskEvent(sortOption: 1));
                        break;
                      case 2:
                        context
                            .read<TaskBloc>()
                            .add(SortTaskEvent(sortOption: 2));
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/calendar.svg',
                              width: 15,
                            ),
                            const SizedBox(width: 10),
                            buildText(
                                'Filter by Date',
                                kBlackColor,
                                textSmall,
                                FontWeight.normal,
                                TextAlign.start,
                                TextOverflow.clip)
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/task_checked.svg',
                              width: 15,
                            ),
                            const SizedBox(width: 10),
                            buildText(
                                'Completed Tasks',
                                kBlackColor,
                                textSmall,
                                FontWeight.normal,
                                TextAlign.start,
                                TextOverflow.clip)
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/task.svg',
                              width: 15,
                            ),
                            const SizedBox(width: 10),
                            buildText(
                                'Pending Tasks',
                                kBlackColor,
                                textSmall,
                                FontWeight.normal,
                                TextAlign.start,
                                TextOverflow.clip)
                          ],
                        ),
                      ),
                    ];
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SvgPicture.asset('assets/svgs/filter.svg'),
                  ),
                ),
              ],
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocConsumer<TaskBloc, TaskState>(
                  listener: (context, state) {
                    if (state is LoadTaskFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(getSnackBar(state.error, kRedColor));
                    }

                    if (state is AddTaskFailure || state is UpdateTaskFailure) {
                      context.read<TaskBloc>().add(FetchTaskEvent());
                    }
                  },
                  builder: (context, state) {
                    if (state is TasksLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      );
                    }

                    if (state is LoadTaskFailure) {
                      return Center(
                        child: buildText(
                            state.error,
                            kRedColor,
                            textMedium,
                            FontWeight.w500,
                            TextAlign.center,
                            TextOverflow.clip),
                      );
                    }

                    if (state is FetchTasksSuccess) {
                      //return state.tasks.isNotEmpty || state.isSearching
                      return state.tasks.isNotEmpty || state.isSearching
                          ? Column(
                              children: [
                                BuildTextField(
                                    hint: 'Search Task',
                                    controller: searchController,
                                    inputType: TextInputType.text,
                                    prefixIcon:
                                        const Icon(Icons.search, color: kGrey2),
                                    fillColor: kWhiteColor,
                                    onChange: (value) {
                                      context.read<TaskBloc>().add(
                                          SearchTaskEvent(keywords: value));
                                    }),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: state.tasks.length,
                                    itemBuilder: (context, index) {
                                      return TaskItem(
                                          taskModel: state.tasks[index]);
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const Divider(
                                        color: kGrey3,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svgs/tasks.svg',
                                    height: size.height * .20,
                                    width: size.width,
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  buildText(
                                      'Schedule your tasks',
                                      kBlackColor,
                                      textBold,
                                      FontWeight.w600,
                                      TextAlign.center,
                                      TextOverflow.clip),
                                  buildText(
                                      'Manage your task schedule easily\nand efficiently',
                                      kBlackColor.withOpacity(.5),
                                      textSmall,
                                      FontWeight.normal,
                                      TextAlign.center,
                                      TextOverflow.clip),
                                ],
                              ),
                            );
                    }
                    return Container();
                  },
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, Screens.addTask);
              },
              child: const Icon(
                Icons.add_circle,
                color: kPrimaryColor,
              ),
            )),
      ),
    );
  }
}
