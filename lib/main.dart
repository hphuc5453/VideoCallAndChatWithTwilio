import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilo_programable_video/action_page.dart';
import 'package:twilo_programable_video/participants/participants_cubit.dart';

void main() {
  runApp(const TwilioProgrammableExample());
}

class TwilioProgrammableExample extends StatelessWidget {
  const TwilioProgrammableExample({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ParticipantsCubit>(create: (context) => ParticipantsCubit(conversation: null))
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Twilio Programmable Video'),
          ),
          body: const ActionPage(),
          ),
      ),
    );
  }
}