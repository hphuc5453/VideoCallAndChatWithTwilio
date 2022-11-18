import 'package:flutter/material.dart';
import 'package:twilo_programable_video/room/room_page.dart';

void main() {
  runApp(const TwilioProgrammableVideoExample());
}

class TwilioProgrammableVideoExample extends StatelessWidget {
  const TwilioProgrammableVideoExample({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Twilio Programmable Video'),
        ),
        body: RoomPage(),
        ),
    );
  }
}