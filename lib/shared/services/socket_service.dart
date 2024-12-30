import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {

  ServerStatus serverStatus = ServerStatus.Connecting;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){
    Socket socket = io('http://10.0.2.2:3000', 
      OptionBuilder()
        .setTransports(['websocket']) // for Flutter or Dart VM // disable auto-connection
        .build()
    );
    socket.connect();

    socket.onConnect((_) {
      serverStatus = ServerStatus.Online;
      print('connect');
      notifyListeners();
    });

    socket.onDisconnect((_) {
      serverStatus = ServerStatus.Offline;
      print('disconnect');
      notifyListeners();
    });

  }

}