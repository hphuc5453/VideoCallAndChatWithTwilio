import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilo_programable_video/chat/message_widget.dart';
import 'package:twilo_programable_video/conversation_list/conversations_data.dart';
import '../progress/progress_widget.dart';
import 'chat_cubit.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.conversation}) : super(key: key);
  final Conversations conversation;
  final messageInputController = TextEditingController();

  @override
  State<ChatPage> createState() => _ChatPageState();
}

Widget _buildBody(BuildContext context, TextEditingController controller) {
  final chatCubit = context.read<ChatCubit>();
  return SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: ListView.builder(
              itemCount: chatCubit.messageList.length,
                itemBuilder: (_, index) {
                  return MessageWidget();
                }
            ),
          ),
        ),
        _buildMessageInputBar(context, controller),
      ],
    ),
  );
}

Widget _buildMessageInputBar(BuildContext context, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, left: 8, bottom: 4),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter message',
                contentPadding: EdgeInsets.only(left: 12, right: 12, bottom: 4, top: 4),
              ),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: SizedBox(
          child: IconButton(
            color: Colors.blue,
            icon: const Icon(Icons.send),
            onPressed: () => {
              context.read<ChatCubit>().sendMessage(controller.text)
            },
          ),
        ),)
      ],
    ),
  );
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
            return _buildBody(context, widget.messageInputController);
          }
          return Container();
        },
      ),
    );
  }
}
