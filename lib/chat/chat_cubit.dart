import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../shared/twilio_service.dart';

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

class ChatLoaded extends ChatState {
  final String name;
  final String token;
  final String identity;

  const ChatLoaded({required this.name, required this.token, required this.identity});
  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatCubit extends Cubit<ChatState> {
  final TwilioFunctionsService backendService;
  String? name;

  ChatCubit({required this.backendService}) : super(ChatInitial());

  submit() async {
    emit(ChatLoading());
  }
}