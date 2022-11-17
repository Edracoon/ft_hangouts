import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

import '../contact_model.dart';

class Message extends StatelessWidget {
  const Message(this.message, this.contact, { Key? key }) : super(key: key);
  final SmsMessage message;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
      child: Align(
        alignment: (message.type != SmsType.MESSAGE_TYPE_SENT) ? Alignment.topLeft : Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (message.type != SmsType.MESSAGE_TYPE_SENT) ? Colors.blue[200] : Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Text('${message.body}', style: const TextStyle(fontSize: 15),),
        ),
      ),
    );
  }
}