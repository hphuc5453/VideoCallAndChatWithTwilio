import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import '../shared/twilio_service.dart';
import 'conversations_data.dart';

abstract class ConversationListState extends Equatable {
  const ConversationListState();

  @override
  List<Object> get props => [];
}

class ConversationListInitial extends ConversationListState {}

class ConversationListLoaded extends ConversationListState {}

class ConversationListLoading extends ConversationListState {}

class ConversationListError extends ConversationListState {
  final String error;

  const ConversationListError({required this.error});

  @override
  List<Object> get props => [error];
}

class ConversationListCubit extends Cubit<ConversationListState> {
  final TwilioFunctionsService backendService;
  late List<Conversations> _conversations = [];

  List<Conversations> get conversationList => _conversations;
  late final ChatClient? chatClient;

  ConversationListCubit({required this.backendService}) : super(ConversationListInitial()) {
    submit();
  }

  submit() async {
    emit(ConversationListLoading());
    String? token;
    try {
      final twilioRoomTokenResponse = await backendService.createToken('hphuc');
      token = twilioRoomTokenResponse['accessToken'];
      if (token != null) {
        chatClient = await TwilioProgrammableChat.create(token, Properties());
        print('Your Identity: ${chatClient?.myIdentity}');
        getMyConversations(token);
      } else {
        emit(const ConversationListError(error: 'Access token is empty!'));
      }
    } catch (e) {
      emit(const ConversationListError(error: 'Something wrong happened when getting the access token'));
    } finally {}
  }

  void getMyConversations(String token) async {
    Map<String, String> requestHeaders = TwilioFunctionsService.getHeaders();
    final response = await get(Uri.parse('https://conversations.twilio.com/v1/Conversations'), headers: requestHeaders);
    if (response.statusCode == 200) {
      final conversations = ConversationsData.fromJson(jsonDecode(response.body));
      _conversations = (conversations.conversations ?? []);
    }
    reload();
  }

  void onChannelAdded(Channel channel) {
    print('[ APPDEBUG ] ConversationListState.onChannelAdded() with name ${channel.getFriendlyName()}');
    reload();
  }

  void onChannelDeleted(Channel channel) {
    print('[ APPDEBUG ] ConversationListState.onChannelDeleted() with name ${channel.getFriendlyName()}');
    reload();
  }

  void onChannelUpdated(ChannelUpdatedEvent channel) {
    print('[ APPDEBUG ] ConversationListState.onChannelUpdated()');
    reload();
  }

  reload() {
    emit(ConversationListInitial());
    emit(ConversationListLoaded());
  }
}
