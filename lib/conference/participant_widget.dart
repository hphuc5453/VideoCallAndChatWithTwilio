import 'package:flutter/material.dart';

class ParticipantWidget extends StatelessWidget {
  final Widget child;
  final String? id;

  const ParticipantWidget({Key? key,
    required this.child,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
