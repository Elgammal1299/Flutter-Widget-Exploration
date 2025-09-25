import 'package:flutter/material.dart';
import 'package:flutter_widget_exploration/Advanced%20Animation%20Chain/loaging_animatin_page.dart';
import 'package:flutter_widget_exploration/iInteractive_dismissible_lists/task_manager.dart';
import 'package:flutter_widget_exploration/interactive_physics_widget/interactive_physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const InteractivePhysics(),
    );
  }
}
