import 'package:flutter/material.dart';
import 'package:moxie_labs_test/providers/clock_manager.dart';
import 'package:moxie_labs_test/screens/clock_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ClockManager>(
          create: (_) => ClockManager(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClockScreen(),
    );
  }
}
