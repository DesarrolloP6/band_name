import 'dart:ffi';

import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bandas = [
    Band(id: '1',name: 'Metalica',votes: 5)
    , Band(id: '2',name: 'AC/DC',votes: 1)
    , Band(id: '3',name: 'Green Day',votes: 4)
    , Band(id: '4',name: 'Avenged Sevenfold',votes: 8)
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Nombre de Bandas', style: TextStyle(color: Colors.black54),),
      ),
      body: ListView.builder(
        itemCount: bandas.length,
        itemBuilder: ( _ , idx ) => _bandTitle(bandas[idx])
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child:const Icon(Icons.add),
      ),
   );
  }

  Widget _bandTitle(Band banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('Direccion $direction');
        print('Id Band: ${banda.id}');
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child:  Text('Delet Band',style: TextStyle(color: Colors.white),)),
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(banda.name.substring(0,2)),
            ),
            title: Text(banda.name),
            trailing: Text('${banda.votes}', style: const TextStyle(fontSize: 20),),
            onTap: () => print(banda.name),
          ),
    );
  }

  addNewBand(){
    final textController = TextEditingController();


    showDialog(
      context: context
      , builder: (context) {
        return  AlertDialog(
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
        );
      },
      );
  }

  addBandToList(String name){
    if (name.trim().length == 0 ) return;

    bandas.sort(((a, b) => a.id.compareTo(b.id)));

    String lastId = (int.parse(bandas.last.id) + 1).toString();

    Band nuevaBanda =  Band(
      id: lastId,
      name: name,
      votes: 0
    );
    bandas.add(nuevaBanda);

    setState(() {});

    Navigator.pop(context);

  }

}