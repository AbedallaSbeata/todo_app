import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/LayoutCubit/states.dart';
import '../LayoutCubit/cubit.dart';


class Tasks extends StatelessWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var cubit = LayoutCubit.get(context);
        return  ListView.separated(
          itemBuilder: (context, index) => Dismissible(
            key: Key(cubit.newTasks[index]["id"].toString()),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.all(Radius.circular(20)),
                  color: Colors.grey[300],
                ),
                padding: EdgeInsetsDirectional.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text("${cubit.newTasks[index]["time"]}",style: TextStyle(fontWeight: FontWeight.bold,)),
                      radius: 30,
                      backgroundColor: Colors.blue,
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${cubit.newTasks[index]["title"]}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text("${cubit.newTasks[index]["date"]}",style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        cubit.updateData(status: "done", id: cubit.newTasks[index]["id"]);
                      },
                      icon: Icon(Icons.check_circle,color: Colors.green,),
                    ),
                    IconButton(
                      onPressed: (){
                        cubit.updateData(status: "archive", id: cubit.newTasks[index]["id"]);
                      },
                      icon: Icon(Icons.archive_outlined,color: Colors.black,),
                    ),
                  ],
                ),
              ),
            ),
            onDismissed: (direction) {
              cubit.deleteData(id: cubit.newTasks[index]["id"]);
            },
          ),
          separatorBuilder: (context,index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey),
          ),
          itemCount: LayoutCubit.get(context).newTasks.length,
        );
      },
    );
  }
}