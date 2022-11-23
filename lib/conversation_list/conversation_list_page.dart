import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilo_programable_video/conversation_list/conversation_widget.dart';
import 'package:twilo_programable_video/progress/progress_widget.dart';
import 'conversation_list_cubit.dart';

class ConversationListPage extends StatefulWidget {
  const ConversationListPage({Key? key}) : super(key: key);

  @override
  State<ConversationListPage> createState() => _ConversationListPageState();
}

Widget _buildBody(BuildContext context) {
  final conversations = context.read<ConversationListCubit>();
  if (conversations.conversationList.isNotEmpty) {
    return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        itemCount: conversations.conversationList.length,
        itemBuilder: (_, index) {
          return ConversationWidget(conversation: conversations.conversationList[index]);
        });
  } else {
    return Container();
  }
}

class _ConversationListPageState extends State<ConversationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
      ),
      body: BlocConsumer<ConversationListCubit, ConversationListState>(
        listener: (context, state) {},
        builder: (_, state) {
          if (state is ConversationListLoading) {
            return const ProgressWidget(description: 'Loading conversations ...');
          }
          if (state is ConversationListLoaded) {
            return _buildBody(context);
          }
          return Container();
        },
      ),
    );
  }
}
