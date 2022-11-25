import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twilo_programable_video/app_constants.dart';
import '../shared/twilio_service.dart';
import 'conversation_list_cubit.dart';
import 'conversation_list_page.dart';

class IdentityInputWidget extends StatefulWidget {
  const IdentityInputWidget({Key? key}) : super(key: key);

  @override
  State<IdentityInputWidget> createState() => _IdentityInputWidgetState();
}

class _IdentityInputWidgetState extends State<IdentityInputWidget> {
  final _identityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identity'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: const Key('enter-identity'),
                    decoration: const InputDecoration(
                      labelText: 'Enter your identity',
                    ),
                    controller: _identityController,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      AppConstants.setIdentity(_identityController.text);
                      Navigator.of(context).push(MaterialPageRoute<ConversationListPage>(
                          builder: (BuildContext context) => BlocProvider(
                                create: (BuildContext context) => ConversationListCubit(backendService: TwilioFunctionsService.instance)..submit(),
                                child: const ConversationListPage(),
                              )));
                    },
                    child: const Text('Confirm'),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
