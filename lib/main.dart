import 'package:flutter/material.dart';

import 'package:app_workspace_socket/src/sevices/socket_service.dart';
import 'package:provider/provider.dart';

import 'src/views/home_view.dart';
import 'src/views/status_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter App',
        initialRoute: 'status',
        routes: {
          'home': (_) => const HomeView(),
          'status': (_) => const StatusView()
        },
      ),
    );
  }
}
