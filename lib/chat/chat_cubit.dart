import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twilio_conversations/twilio_conversations.dart';

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
  final List<Participant> participants;
  const ChatParticipantsLoaded({required this.participants});
}

class ChatCubit extends Cubit<ChatState> {
  final Conversation conversation;
  late final List<Message> _messages = [];
  List<Message> get messageList => _messages;
  final subscriptions = <StreamSubscription>[];

  ChatCubit({required this.conversation}) : super(ChatInitial());

  getParticipants() async {
    emit(ChatParticipantsLoading());
    print('[ChatDebug] getParticipants');
    await conversation.getParticipantsList().then((value) => {
    emit(ChatParticipantsLoaded(participants: value))
    });
  }

  addUserByIdentity(String identity) async {
    print('[ChatDebug] addUserByIdentity');
    await conversation.addParticipantByIdentity(identity);
    await conversation.getParticipantsList();
  }

  removeParticipant(Participant participant) async {
    await participant.remove();
    await getParticipants();
  }

  sendMessage(String message) async {
    try {
      // set arbitrary attributes
      final attributesData = <String, dynamic>{
        'importance': 'high'
      };
      final attributes =
      Attributes(AttributesType.OBJECT, jsonEncode(attributesData));
      final messageOptions = MessageOptions()
        ..withBody(message)
        ..withAttributes(attributes);
      await conversation.sendMessage(messageOptions);
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
    if (numberOfMessages != null) {
      final nextMessages = await conversation.getLastMessages(numberOfMessages);
      if (nextMessages.isNotEmpty) {
        _messages.clear();
        _messages.addAll(nextMessages.reversed);
      }
    }
    await conversation.setAllMessagesRead();
    reload();
  }

  reload() {
    emit(ChatInitial());
    emit(ChatLoaded());
  }
}