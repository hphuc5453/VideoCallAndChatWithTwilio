import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twilio_conversations/twilio_conversations.dart';
import 'package:twilo_programable_video/app_constants.dart';
import '../shared/twilio_service.dart';

abstract class ConversationListState extends Equatable {
  const ConversationListState();

  @override
  List<Object> get props => [];
}

class ConversationListInitial extends ConversationListState {}

class ConversationListLoaded extends ConversationListState {
  final List<Conversation> conversations;

  const ConversationListLoaded({required this.conversations});
}

class ConversationListLoading extends ConversationListState {}

class ConversationListError extends ConversationListState {
  final String error;

  const ConversationListError({required this.error});

  @override
  List<Object> get props => [error];
}

class ConversationListCubit extends Cubit<ConversationListState> {
  final TwilioFunctionsService backendService;
  final plugin = TwilioConversations();
  final subscriptions = <StreamSubscription>[];

  ConversationListCubit({required this.backendService}) : super(ConversationListInitial());

  join(Conversation conversation) async {
    await conversation.join();
  }

  submit() async {
    emit(ConversationListLoading());
    String? token;
    try {
      final twilioRoomTokenResponse = await backendService.createToken(AppConstants.getIdentity);
      token = twilioRoomTokenResponse['accessToken'];
      if (token != null) {
        await create(jwtToken: token);
      } else {
        emit(const ConversationListError(error: 'Access token is empty!'));
      }
    } catch (e) {
      emit(const ConversationListError(error: 'Something wrong happened when getting the access token'));
    } finally {}
  }

  create({required String jwtToken}) async {
    await TwilioConversations.debug(dart: true, native: true, sdk: false);

    print('debug logging set, creating client...');
    await plugin.create(jwtToken: jwtToken).then((client) {
      print('Client initialized');
      print('Your Identity: ${client?.myIdentity}');

      subscriptions.add(client!.onConversationAdded.listen((event) {
        getMyConversations();
      }));

      subscriptions.add(client.onConversationUpdated.listen((event) {
        getMyConversations();
      }));

      subscriptions.add(client.onConversationDeleted.listen((event) {
        getMyConversations();
      }));

      getMyConversations();
    });
  }

  createConversation({String friendlyName = 'Test Conversation'}) async {
    var result = await TwilioConversations.conversationClient?.createConversation(friendlyName: friendlyName);
    print('Conversation successfully created: ${result?.friendlyName}');
    await getMyConversations();
  }

  getMyConversations() async {
    print('[AppDebug] getMyConversations');
    await TwilioConversations.conversationClient?.getMyConversations().then((conversations) {
      //TODO: With iOS, the library cannot get the friendly name of conversation fastly
      Timer(const Duration(seconds: 3), () {
        emit(ConversationListInitial());
        emit(ConversationListLoaded(conversations: conversations));
      });
    });
  }
}
