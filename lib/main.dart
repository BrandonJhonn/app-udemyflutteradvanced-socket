import 'package:flutter/material.dart';

import 'src/views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      initialRoute: 'homeview',
      routes: {
        'homeview': (_) => const HomeView()
      },
    );
  }
}
