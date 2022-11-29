import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twilio_programmable_chat/twilio_programmable_chat.dart';
import 'package:twilo_programable_video/app_constants.dart';
import '../shared/twilio_service.dart';

abstract class ConversationListState extends Equatable {
  const ConversationListState();

  @override
  List<Object> get props => [];
}

class ConversationListInitial extends ConversationListState {}

class ConversationListLoaded extends ConversationListState {
  final List<ChannelDescriptor> conversations;

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
  final subscriptions = <StreamSubscription>[];
  late ChatClient? chatClient;

  ConversationListCubit({required this.backendService}) : super(ConversationListInitial());

  join(ChannelDescriptor channelDescriptor) async {
    final channel = await channelDescriptor.getChannel();
    if (channel == null) {
      return;
    }
    if (channel.status != ChannelStatus.JOINED) {
      await channel.join();
    }
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
    await TwilioProgrammableChat.debug(dart: true, native: true, sdk: false);

    print('debug logging set, creating client...');
    chatClient = (await TwilioProgrammableChat.create(jwtToken, Properties()));
    if (chatClient != null) {
      print('Client initialized');
      print('Your Identity: ${chatClient?.myIdentity}');

      subscriptions.add(chatClient!.onChannelAdded.listen((event) {
        getMyConversations();
      }));

      subscriptions.add(chatClient!.onChannelUpdated.listen((event) {
        getMyConversations();
      }));

      subscriptions.add(chatClient!.onChannelDeleted.listen((event) {
        getMyConversations();
      }));

      getMyConversations();
    }
  }

  createConversation({String friendlyName = 'Test Conversation'}) async {
    await chatClient?.channels.createChannel(friendlyName, ChannelType.PRIVATE);
    print('Conversation created successfully');
    await getMyConversations();
  }

  getMyConversations() async {
    print('[AppDebug] getMyConversations');
    await chatClient?.channels.getUserChannelsList().then((conversations) {
      emit(ConversationListInitial());
      emit(ConversationListLoaded(conversations: conversations.items));
    });
  }
}
