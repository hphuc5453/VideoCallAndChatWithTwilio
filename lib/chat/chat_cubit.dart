import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

import '../app_constants.dart';
import '../shared/twilio_service.dart';
import 'messages_data.dart';

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

class ChatCubit extends Cubit<ChatState> {
  final String conversationId;
  late List<Message> _messages = [];
  List<Message> get messageList => _messages;

  ChatCubit({required this.conversationId}) : super(ChatInitial()) {
    submit();
  }

  sendMessage(String message) async {
    String creds = '${AppConstants.accountSID}:${AppConstants.authToken}';
    var bytes = utf8.encode(creds);
    Map<String, String> requestHeaders = {'Authorization': 'Basic ${base64.encode(bytes)}'};
    try {
      // set arbitrary attributes
      final attributesData = <String, dynamic>{
        'body': message,
        'author': 'hphuc'
      };
      final response = await post(Uri.parse('${AppConstants.domainURL}/Conversations/$conversationId/Messages'), headers: requestHeaders, body: attributesData);
      if (response.statusCode == 201) {
        reload();
      }
    } catch (e) {
      print('Failed to send message Error: $e');
    }
  }

  submit() async {
    emit(ChatLoading());
    Map<String, String> requestHeaders = TwilioFunctionsService.getHeaders();
    final response = await get(Uri.parse('${AppConstants.domainURL}/Conversations/$conversationId/Messages'), headers: requestHeaders);
    if (response.statusCode == 200) {
      print('xxxxxxxx: ${response.body}');
    }
    reload();
  }

  reload() {
    emit(ChatInitial());
    emit(ChatLoaded());
  }
}