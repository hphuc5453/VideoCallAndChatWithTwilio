import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilo_programable_video/app_constants.dart';
import 'package:twilo_programable_video/room/room_cubit.dart';
import 'package:twilo_programable_video/shared/twilio_service.dart';
import '../conference/conference_cubit.dart';
import '../conference/conference_page.dart';

class RoomPage extends StatelessWidget {
  RoomPage({Key? key}) : super(key: key);
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) =>
                RoomCubit(backendService: TwilioFunctionsService.instance),
            child: BlocConsumer<RoomCubit, RoomState>(
              listener: (context, state) async {
                if (state is RoomLoaded) {
                  await Navigator.of(context).push(
                    MaterialPageRoute<ConferencePage>(
                        fullscreenDialog: true,
                        builder: (BuildContext context) =>
                        BlocProvider(
                          create: (BuildContext context) => ConferenceCubit(
                            identity: state.identity,
                            token: state.token,
                            name: state.identity,
                          ),
                          child: const ConferencePage(),
                        )),
                  );
                }
              },
              builder: (context, state) {
                var isLoading = false;
                RoomCubit bloc = context.read<RoomCubit>();
                if (state is RoomLoading) {
                  isLoading = true;
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                key: const Key('enter-name'),
                                decoration: InputDecoration(
                                  labelText: 'Enter your name',
                                  enabled: !isLoading,
                                ),
                                controller: _nameController,
                                onChanged: (newValue) =>
                                    AppConstants.setIdentity(newValue),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              (isLoading == true)
                                  ? const LinearProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await bloc.submit();
                                      },
                                      child: const Text('Enter the video room')),
                              (state is RoomError)
                                  ? Text(
                                      state.error,
                                      style: const TextStyle(color: Colors.red),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        )
                      ]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
