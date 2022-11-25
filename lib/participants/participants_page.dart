// import 'package:flutter/material.dart';
// import 'package:twilio_conversations/twilio_conversations.dart';
//
// class ParticipantsPageWidget extends StatefulWidget {
//   const ParticipantsPageWidget({Key? key, required this.participants}) : super(key: key);
//
//   final List<Participant> participants;
//
//   @override
//   State<ParticipantsPageWidget> createState() => _ParticipantsPageWidgetState();
// }
//
// class _ParticipantsPageWidgetState extends State<ParticipantsPageWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       width: 140,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.participants.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final participant = widget.participants[index];
//                 return InkWell(
//                   onLongPress: () {
//                     cubit.removeParticipant(cubit.participants[index]);
//                   },
//                   child: Row(
//                     children: [
//                       Text(participant.identity ?? 'UNKNOWN'),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   decoration: const InputDecoration(label: Text('User Identity')),
//                   controller: controller,
//                 ),
//               ),
//               IconButton(
//                 onPressed: () async {
//                   cubit.addUserByIdentity(controller.text);
//                   controller.clear();
//                 },
//                 icon: const Icon(Icons.add),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
