import 'package:flutter/material.dart';
import 'package:todo_app/home/home.dart';
import 'Dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Home(),
    );
  }
}


