import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilo_programable_video/conversation_list/conversations_data.dart';
import '../progress/progress_widget.dart';
import 'chat_cubit.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.conversation}) : super(key: key);
  final Conversations conversation;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.friendlyName!),
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        builder: (_, state) {
          if (state is ChatLoading) {
            return const ProgressWidget(description: 'Loading chat ...');
          }
          if (state is ChatLoaded) {
            return Container();
          }
          return Container();
        },
      ),
    );
  }
}

