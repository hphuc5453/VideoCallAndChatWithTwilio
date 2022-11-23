import 'package:flutter/material.dart';

class ProgressWidget extends StatelessWidget {
  final String description;
  const ProgressWidget({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Center(child: CircularProgressIndicator()),
          const SizedBox(
            height: 10,
          ),
          Text(
            description,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
