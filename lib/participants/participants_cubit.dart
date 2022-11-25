import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twilio_conversations/twilio_conversations.dart';

abstract class ParticipantsState extends Equatable {
  const ParticipantsState();
  @override
  List<Object> get props => [];
}

class ParticipantsInitial extends ParticipantsState {}
class ParticipantsLoading extends ParticipantsState {}
class ParticipantsLoaded extends ParticipantsState {}
class ParticipantsCubit extends Cubit<ParticipantsState> {
  List<Participant> participants = [];
  final Conversation? conversation;
  ParticipantsCubit({required this.conversation}) : super(ParticipantsInitial()) {
    init();
  }

  addUserByIdentity(String identity) async {
    print('[ChatDebug] addUserByIdentity');
    await conversation?.addParticipantByIdentity(identity);
    await getParticipants();
    reload();
  }

  removeParticipant(Participant participant) async {
    await participant.remove();
    await getParticipants();
    reload();
  }

  getParticipants() async {
    print('[ChatDebug] getParticipants');
    participants = await conversation!.getParticipantsList();
  }

  init() async {
    emit(ParticipantsLoading());
    await getParticipants();
    reload();
  }

  reload() {
    emit(ParticipantsInitial());
    emit(ParticipantsLoaded());
  }
}