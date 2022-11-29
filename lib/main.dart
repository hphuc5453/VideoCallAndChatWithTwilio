import 'package:flutter/material.dart';
import 'package:twilo_programable_video/action_page.dart';

void main() {
  runApp(const TwilioProgrammableExample());
}

class TwilioProgrammableExample extends StatelessWidget {
  const TwilioProgrammableExample({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Twilio Programmable Video'),
        ),
        body: const ActionPage(),
        ),
    );
  }
}