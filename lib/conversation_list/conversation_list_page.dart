import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilo_programable_video/conversation_list/conversation_widget.dart';
import 'package:twilo_programable_video/progress/progress_widget.dart';
import 'package:twilo_programable_video/shared/twilio_service.dart';
import 'conversation_list_cubit.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

Widget _buildBody(BuildContext context, List<ChannelDescriptor> conversations) {
  if (conversations.isNotEmpty) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        itemCount: conversations.length,
        itemBuilder: (_, index) {
          return ConversationWidget(conversation: conversations[index]);
        });
  } else {
    return const Center(child: Text('Conversations empty'));
  }
}

enum ConversationsPageMenuOptions { create }

_showCreateConversationDialog(BuildContext context) {
  TextEditingController controller = TextEditingController();
  return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Create Conversation'),
          content: BlocProvider<ConversationListCubit>(
            create: (context) => ConversationListCubit(backendService: TwilioFunctionsService.instance),
            child: BlocConsumer<ConversationListCubit, ConversationListState>(
              listener: (context, state) {},
              builder: (_, state) {
                return SizedBox(
                  height: 200,
                  width: 140,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(label: Text('Conversation name')),
                              controller: controller,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await context.read<ConversationListCubit>().createConversation(friendlyName: controller.text);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.add),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      });
}

class _ConversationListPageState extends State<ConversationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        actions: [
          PopupMenuButton(
            onSelected: (result) {
              switch (result) {
                case ConversationsPageMenuOptions.create:
                  _showCreateConversationDialog(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ConversationsPageMenuOptions>>[
              const PopupMenuItem(
                value: ConversationsPageMenuOptions.create,
                child: Text('Create conversation'),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<ConversationListCubit, ConversationListState>(
        listener: (context, state) {},
        builder: (_, state) {
          if (state is ConversationListLoading) {
            return const ProgressWidget(description: 'Loading conversations ...');
          }
          if (state is ConversationListLoaded) {
            return _buildBody(context, state.conversations);
          }
          return Container();
        },
      ),
    );
  }
}
