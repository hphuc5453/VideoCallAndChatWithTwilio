import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilo_programable_video/app_constants.dart';
import 'package:twilo_programable_video/chat/message_widget.dart';
import '../progress/progress_widget.dart';
import 'chat_cubit.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.conversation}) : super(key: key);
  final ChannelDescriptor conversation;
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
                reverse: true,
                itemCount: chatCubit.messageList.length,
                itemBuilder: (_, index) {
                  return MessageWidget(
                      message: chatCubit.messageList[index],
                      isMyMessage: chatCubit.messageList[index].author == AppConstants.getIdentity);
                }),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            child: IconButton(
              color: Colors.blue,
              icon: const Icon(Icons.send),
              onPressed: () => {context.read<ChatCubit>().sendMessage(controller.text), controller.clear()},
            ),
          ),
        )
      ],
    ),
  );
}

enum MessagesPageMenuOptions { participants }

_showManageParticipantsDialog(BuildContext context, Channel conversation) async {
  TextEditingController controller = TextEditingController();
  return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
            title: const Text('Manage Participants'),
            content: BlocProvider<ChatCubit>(
              create: (context) => ChatCubit(conversation: conversation)..getParticipants(),
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {},
                builder: (_, state) {
                  print('xxxxxxxxx: AlertDialog $state');
                  if (state is ChatParticipantsLoading) {
                    return const SizedBox(width: 140, height: 200,);
                  }
                  if (state is ChatParticipantsLoaded) {
                    final cubit = context.read<ChatCubit>();
                    return SizedBox(
                      height: 200,
                      width: 140,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.participants.length,
                              itemBuilder: (BuildContext context, int index) {
                                final participant = state.participants[index];
                                return InkWell(
                                  onLongPress: () async {
                                    await cubit.removeParticipant(state.participants[index]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Row(
                                    children: [
                                      Text(participant.identity ?? 'UNKNOWN', style: const TextStyle(
                                        color: Colors.green
                                      ),),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(label: Text('User Identity')),
                                  controller: controller,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await cubit.addParticipant(controller.text);
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.add),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox(width: 140, height: 200,);
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('CLOSE'),
              )
            ],
        );
      });
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.conversation.friendlyName ?? 'UNKNOWN'),
          actions: [
            PopupMenuButton(
              onSelected: (result) async {
                switch (result) {
                  case MessagesPageMenuOptions.participants:
                    final channel = await widget.conversation.getChannel();
                    _showManageParticipantsDialog(context, channel!);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<MessagesPageMenuOptions>>[
                const PopupMenuItem(
                  value: MessagesPageMenuOptions.participants,
                  child: Text('Participants'),
                ),
              ],
            ),
          ],
        ),
        body: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {},
          builder: (_, state) {
            print('xxxxxxxxx $state');
            if (state is ChatLoading) {
              return const ProgressWidget(description: 'Loading chat ...');
            }
            if (state is ChatLoaded || state is ChatParticipantsLoaded || state is ChatParticipantsLoading) {
              return _buildBody(context, widget.messageInputController);
            }
            return Container();
          },
        ),
    );
  }
}
