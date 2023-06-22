import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../LayoutCubit/cubit.dart';
import '../LayoutCubit/states.dart';

class Home extends StatelessWidget {
  var formSaffold = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      LayoutCubit()..createDatabase(),
      child: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
            titleController.clear();
            timeController.clear();
            dateController.clear();
          }
        },
        builder: (context, state) {
          var cubit = LayoutCubit.get(context);
          return Scaffold(
            key: formSaffold,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              mini: false,
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                }
                else {
                  formSaffold.currentState!.showBottomSheet((context) {
                    return Container(
                      padding: EdgeInsets.all(20),
                      width: double.infinity,
                      //height: 320,
                      color: Colors.white,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: "Title",
                                prefixIcon: Icon(Icons.title),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Title must be not empty';
                                return null;
                              },
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              onTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now()).then((value) {
                                  timeController.text =
                                      value!.format(context).toString();
                                });
                              },
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: "Time",
                                prefixIcon: Icon(Icons.access_time_outlined),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Time must be not empty';
                                return null;
                              },
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              onTap: () {
                                showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2025-01-01'),
                                ).then((value) {
                                  dateController.text =
                                      DateFormat.yMMMd()
                                          .format(value!)
                                          .toString();
                                });
                              },
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                labelText: "Date",
                                prefixIcon: Icon(Icons.date_range_outlined),
                              ),
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Date must be not empty';
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).closed.then((value) {
                    cubit.changeBottomSheet(
                        icon: Icons.edit,  isShow: false);
                  });
                  cubit.changeBottomSheet(
                      icon: Icons.add, isShow: true);
                }
              },
            ),
            appBar: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black,
              unselectedItemColor: Colors.white,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  Center(
                    child: CircularProgressIndicator(),
                  ),
            ),
          );
        },
      ),
    );
  }
}

