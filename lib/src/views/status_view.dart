import 'package:flutter/material.dart';

import 'package:app_workspace_socket/src/sevices/socket_service.dart';
import 'package:provider/provider.dart';


class StatusView extends StatelessWidget {
  const StatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Estado Servidor: ${socketService.serverStatus}')
          ],
        ),
     ),
     floatingActionButton: FloatingActionButton(
       child: const Icon(Icons.message),
       onPressed: () {
         socketService.socket.emit('emitir-mensaje', {
           'nombre': 'Flutter', 
           'mensaje': 'Hola desde Flutter'
          });
       },
     ),
   );
  }
}