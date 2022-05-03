import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../models/band.dart';
import '../sevices/socket_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Band> bands = [
  //  Band(id: '1', name: 'AC/DC', votes: 5),
  //  Band(id: '2', name: 'PXNDX', votes: 10),
  //  Band(id: '3', name: 'PAPA ROACH', votes: 3),
  //  Band(id: '4', name: 'MUSE', votes: 12),
  ];

  void _getActiveBands(dynamic payload) {
    bands = (payload as List).map((e) => Band.fromMap(e)).toList();
    setState(() {});
  }

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _getActiveBands);
    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Bandas', style: TextStyle(
          color: Colors.black87,
        ),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.onLine)
            ? const Icon(Icons.flash_on, color: Colors.green,)
            : const Icon(Icons.flash_off, color: Colors.red,),
          ),
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i])
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: addNewBand,
        elevation: 1,
      ),
   );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.socket.emit('delete-band', {'id': band.id}),
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
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  addNewBand() {
    final ctrTextFieldName = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context, 
        builder: (_) => AlertDialog(
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
          )
      );
    } else {
      return showCupertinoDialog(
        context: context, 
        builder: (_) => CupertinoAlertDialog(
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
          )
      );
    }
  }

  void addBandToList(String name) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = <String, double>{};
    for(Band e in bands) {
      dataMap.putIfAbsent(e.name, () => e.votes.toDouble());
    }

    List<Color> colorList = [
      Color(Colors.blue[50]!.value),
      Color(Colors.blue[100]!.value),
      Color(Colors.red[50]!.value),
      Color(Colors.red[100]!.value),
      Color(Colors.yellow[50]!.value),
      Color(Colors.yellow[100]!.value),
      Color(Colors.green[50]!.value),
      Color(Colors.green[100]!.value),
    ]; 

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: (dataMap.isNotEmpty) 
      ? PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(milliseconds: 800),
          chartLegendSpacing: 35,
          chartRadius: MediaQuery.of(context).size.width / 2.5,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 15,
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
            decimalPlaces: 0,
          ),
        )
      : Container(),
    );
  }
}