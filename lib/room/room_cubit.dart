import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twilo_programable_video/app_constants.dart';
import '../shared/twilio_service.dart';

abstract class RoomState extends Equatable {
  const RoomState();
  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomError extends RoomState {
  final String error;
  const RoomError({required this.error});
  @override
  List<Object> get props => [error];
}

class RoomLoaded extends RoomState {
  final String name;
  final String token;
  final String identity;

  const RoomLoaded({required this.name, required this.token, required this.identity});
  @override
  List<Object> get props => [];
}

class RoomLoading extends RoomState {}

class RoomCubit extends Cubit<RoomState> {
  final TwilioFunctionsService backendService;

  RoomCubit({required this.backendService}) : super(RoomInitial());

  submit() async {
    emit(RoomLoading());
    String? token;
    String? identity;
    try {
      final twilioRoomTokenResponse = await backendService.createToken(AppConstants.getIdentity);
      token = twilioRoomTokenResponse['accessToken'];
      identity = AppConstants.getIdentity;

      if (token != null) {
        emit(RoomLoaded(name: identity ?? '', token: token, identity: identity));
      } else {
        emit(const RoomError(error: 'Access token is empty!'));
      }
    } catch (e) {
      emit(const RoomError(error: 'Something wrong happened when getting the access token'));
    } finally {}
  }
}

