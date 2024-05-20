import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bandas = [
    // Band(id: '1',name: 'Metalica',votes: 5)
    // , Band(id: '2',name: 'AC/DC',votes: 1)
    // , Band(id: '3',name: 'Green Day',votes: 4)
    // , Band(id: '4',name: 'Avenged Sevenfold',votes: 8)
  ];

  @override
  void initState() {
    // TODO: implement initState
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    // print(payload as List);
    bandas.clear();

    payload.toList().map((e) {
      bandas.add(Band.fromMap(e));
      return Band.fromMap(e);
    }).toList();

    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.off('active-bands');
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nombre de Bandas',
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: Column(
        children: [       
          showGraf(),   
          Expanded(
            child: ListView.builder(
                itemCount: bandas.length,
                itemBuilder: (_, idx) => _bandTitle(bandas[idx])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTitle(Band banda) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) =>
          socketService.socket.emit('delete-band', {'idBand': banda.id}),
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delet Band',
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(banda.name.substring(0, 2)),
        ),
        title: Text(banda.name),
        trailing: Text(
          '${banda.votes}',
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () =>
            socketService.socket.emit('vote-band', {'idBand': banda.id}),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Band Name'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () => addBandToList(textController.text),
            elevation: 5,
            textColor: Colors.blue,
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  addBandToList(String name) {
    final _socketService = Provider.of<SocketService>(context, listen: false);

    if (name.trim().isEmpty) return;

    _socketService.socket.emit('new-band', {'name': name});
    setState(() {});

    Navigator.pop(context);
  }

  Widget showGraf(){
    // Map<String, double> dataMap = {
    //   "Flutter": 5,
    //   "React": 3,
    //   "Xamarin": 2,
    //   "Ionic": 2,
    // };
    Map<String, double> dataMap= {};

    if (bandas.isEmpty) {
      return Container( 
        width: double.infinity,
        height: 200,
        child: const Text('sindata'),
      );
    }
    bandas.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });

    final List<Color> colorList = [
      Colors.black,
      Colors.amber,
      Colors.blue,
      Colors.brown,
      Colors.cyan,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.green,
      Colors.grey,
    ];

    return Container(
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 400),
        chartLegendSpacing: 50,
        chartRadius: MediaQuery.of(context).size.width / 7,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 20,
        centerText: "Bandas",
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          // legendShape: _BoxShape.circle,
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
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      )
    );
   
  }
}
