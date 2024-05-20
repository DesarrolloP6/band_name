import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  
  late IO.Socket _socket;


  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService(){
    
    _initConfig();
  }

  void _initConfig(){
    
    // _socket = IO.io('http://192.168.30.69:3000/', {
    _socket = IO.io('https://flutter-socket-io-server-75tf.onrender.com/', 
    {
      'transports': ['websocket'],
      'autoconnect':true,
    }
    );
    
    _socket.onConnect((_) {      
      _serverStatus=ServerStatus.online;
      notifyListeners();
    });
    
    _socket.onDisconnect((_) {
      _serverStatus=ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (payload) {
    //   print('Nuevo mensaje:');
    //   print('nombre:'  + payload['nombre']);
    //   print('mensaje:' + payload['mensaje']);
    // });
  }

}