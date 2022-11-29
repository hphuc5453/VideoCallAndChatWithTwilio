import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilo_programable_video/app_constants.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatError extends ChatState {
  final String error;
  const ChatError({required this.error});
  @override
  List<Object> get props => [error];
}

class ChatLoaded extends ChatState {}
class ChatLoading extends ChatState {}
class ChatParticipantsLoading extends ChatState {}
class ChatParticipantsLoaded extends ChatState {
  final List<Member> participants;
  const ChatParticipantsLoaded({required this.participants});
}

class ChatCubit extends Cubit<ChatState> {
  final Channel conversation;
  late final List<Message> _messages = [];
  List<Message> get messageList => _messages;
  final subscriptions = <StreamSubscription>[];

  ChatCubit({required this.conversation}) : super(ChatInitial());

  getParticipants() async {
    emit(ChatParticipantsLoading());
    print('[ChatDebug] getParticipants');
    final membersOfCurrentChannel = await conversation.members.getMembersList();
    if (membersOfCurrentChannel != null) {
      emit(ChatParticipantsLoaded(participants: membersOfCurrentChannel));
    }
  }

  addParticipant(String identity) async {
    print('[ChatDebug] addMember');
    await conversation.members.inviteByIdentity(identity);
    await getParticipants();
  }

  removeParticipant(Member member) async {
    print('[ChatDebug] removeParticipant');
    await conversation.members.remove(member);
    await getParticipants();
  }

  sendMessage(String message) async {
    try {
      final messageOptions = MessageOptions()
        ..withBody(message)
        ..withAttributes({'name': AppConstants.getIdentity});
      await conversation.messages.sendMessage(messageOptions);
      await loadMessages();
    } catch (e) {
      print('[ChatCubit.sendMessage] Failed to send message Error: $e');
    }
  }

  submit() async {
    emit(ChatLoading());
    subscriptions.add(conversation.onMessageAdded.listen((event) {
      loadMessages();
    }));
    loadMessages();
  }

  loadMessages() async {
    final numberOfMessages = await conversation.getMessagesCount();
    final nextMessages = await conversation.messages.getLastMessages(numberOfMessages);
    if (nextMessages.isNotEmpty) {
      _messages.clear();
      _messages.addAll(nextMessages.reversed);
    }
    reload();
  }

  reload() {
    emit(ChatInitial());
    emit(ChatLoaded());
  }
}