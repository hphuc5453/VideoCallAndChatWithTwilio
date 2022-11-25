import 'package:flutter/material.dart';
import 'package:twilio_conversations/twilio_conversations.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({Key? key, required this.message, required this.isMyMessage}) : super(key: key);
  final Message message;
  final bool isMyMessage;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final textColor = widget.isMyMessage ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: widget.isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 4.0),
            constraints: const BoxConstraints(maxWidth: 250, minHeight: 35),
            decoration: BoxDecoration(color: widget.isMyMessage ? Colors.blue : Colors.grey, borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding:
              const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: widget.isMyMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
              Text(
                widget.message.body ?? '',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
