import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'conference_cubit.dart';

class ConferencePage extends StatefulWidget {
  const ConferencePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConferencePageState();
}

class _ConferencePageState extends State<ConferencePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ConferenceCubit, ConferenceState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ConferenceInitial) {
              return showProgress();
            }
            if (state is ConferenceLoaded) {
              return Stack(
                children: <Widget>[
                  _buildParticipants(context),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: IconButton(
                          icon: const Icon(
                            Icons.call_end_sharp,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            context.read<ConferenceCubit>().disconnect();
                            Navigator.of(context).pop();
                          },
                        ),
                      ))
                ],
              );
            }
            return Container();
          }),
    );
  }

  Widget showProgress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const <Widget>[
        Center(child: CircularProgressIndicator()),
        SizedBox(
          height: 10,
        ),
        Text(
          'Connecting to the video room...',
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildParticipants(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final children = <Widget>[];
    _buildOverlayLayout(context, size, children);
    return Stack(children: children);
  }

  void _buildOverlayLayout(
      BuildContext context, Size size, List<Widget> children) {
    final conferenceRoom = context.read<ConferenceCubit>();
    final participants = conferenceRoom.participants;
    children.add(GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemCount: participants.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: participants[index],
          );
        }));
  }
}
