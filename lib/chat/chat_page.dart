import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilo_programable_video/shared/twilio_service.dart';
import 'chat_cubit.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key}) : super(key: key);
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) =>
                ChatCubit(backendService: TwilioFunctionsService.instance),
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {},
              builder: (context, state) {
                var isLoading = false;
                ChatCubit bloc = context.read<ChatCubit>();
                if (state is ChatLoading) {
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
                                    context.read<ChatCubit>().name = newValue,
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
                                      child: const Text('Enter the chat room')),
                              (state is ChatError)
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
