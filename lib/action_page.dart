import 'package:flutter/material.dart';
import 'package:twilo_programable_video/chat/chat_page.dart';
import 'package:twilo_programable_video/room/room_page.dart';

class ActionPage extends StatelessWidget {
  const ActionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoomPage()));
                },
                child: const Text('Enter the video room')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()));
                },
                child: const Text('Enter the chat room'))
          ],
        ),
      ),
    );
  }
}
