import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Band> bands = [
    Band(id: '1', name: 'AC/DC', votes: 5),
    Band(id: '2', name: 'PXNDX', votes: 10),
    Band(id: '3', name: 'PAPA ROACH', votes: 3),
    Band(id: '4', name: 'MUSE', votes: 12),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Bandas', style: TextStyle(
          color: Colors.black87,
        ),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: addNewBand,
        elevation: 1,
      ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('Eliminando: ${band.id}');
        //  TODO: Eliminar registro 
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red[300],
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20.0)),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final ctrTextFieldName = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: const Text('Agregar Item'),
            content: TextField(
              controller: ctrTextFieldName,
            ),
            actions: [
              MaterialButton(
                child: const Text('Agregar'),
                elevation: 5,
                textColor: Colors.blue,
                onPressed: () => addBandToList(ctrTextFieldName.text)
              )
            ],
          );
        }
      );
    } else {
      return showCupertinoDialog(
        context: context, 
        builder: (_) {
          return CupertinoAlertDialog(
            title: const Text('Agregar Item'),
            content: CupertinoTextField(
              controller: ctrTextFieldName,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Agregar'),
                onPressed: () => addBandToList(ctrTextFieldName.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        }
      );
    }
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add(Band(
        id: (bands.length + 1).toString(),
        name: name,
        votes: 0
      ));
      setState(() {});
    }
    Navigator.pop(context);
  }
}