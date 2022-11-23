import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilo_programable_video/conversation_list/conversation_list_cubit.dart';
import 'package:twilo_programable_video/conversation_list/conversation_list_page.dart';
import 'package:twilo_programable_video/room/room_page.dart';
import 'package:twilo_programable_video/shared/twilio_service.dart';

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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RoomPage()));
                },
                child: const Text('Enter the video room')),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute<ConversationListPage>(
                      builder: (BuildContext context) => BlocProvider(
                            create: (BuildContext context) => ConversationListCubit(backendService: TwilioFunctionsService.instance),
                            child: const ConversationListPage(),
                          )));
                },
                child: const Text('Enter the chat room'))
          ],
        ),
      ),
    );
  }
}
