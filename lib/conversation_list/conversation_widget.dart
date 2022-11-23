import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilo_programable_video/chat/chat_cubit.dart';
import 'package:twilo_programable_video/chat/chat_page.dart';
import 'package:twilo_programable_video/conversation_list/conversations_data.dart';

class ConversationWidget extends StatelessWidget {
  final Conversations conversation;

  const ConversationWidget({Key? key, required this.conversation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute<ChatPage>(
            builder: (BuildContext context) => BlocProvider(
              create: (BuildContext context) => ChatCubit(conversationId: conversation.sid!),
              child: ChatPage(conversation: conversation,),
            )));
      },
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                      child: Text(conversation.friendlyName!),
                    ),
                    Container(height: 1, color: Colors.black,)
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
