import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilo_programable_video/chat/chat_cubit.dart';
import 'package:twilo_programable_video/chat/chat_page.dart';
import 'package:twilo_programable_video/conversation_list/conversation_list_cubit.dart';

class ConversationWidget extends StatefulWidget {
  ChannelDescriptor conversation;

  ConversationWidget({Key? key, required this.conversation}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationState();
}

class _ConversationState extends State<ConversationWidget> {
  _navigateToChatRoom(BuildContext context) async {
    final channel = await widget.conversation.getChannel();
    Navigator.of(context).push(MaterialPageRoute<ChatPage>(
        builder: (BuildContext context) => BlocProvider(
          create: (BuildContext context) => ChatCubit(conversation: channel!)..submit(),
          child: ChatPage(conversation: widget.conversation,),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ConversationListCubit>();
    return InkWell(
      onTap: () async {
        await cubit.join(widget.conversation);
        _navigateToChatRoom(context);
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
                      child: Text(widget.conversation.friendlyName ?? 'UNKNOWN'),
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
