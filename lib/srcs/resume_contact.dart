import 'package:flutter/material.dart';
import 'package:ft_hangouts/contact_model.dart';

class ResumeContact extends StatefulWidget {

  final Contact contact;

  const ResumeContact({Key? key, required this.contact}) : super(key: key);

  @override
  State<ResumeContact> createState() => _ResumeContactState();
}

class _ResumeContactState extends State<ResumeContact> {

  String getContactDescription(Contact contact) {
    if (contact.firstname == "" && contact.lastname == "") {
      return contact.number;
    }
    String ret = "${contact.firstname} ${contact.lastname}";
    if (ret.length > 20) {
      ret = "${ret.substring(0, 17)}...";
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded (
          flex: 2,
          child: Icon(Icons.person, size: 35.0),
        ),
        const Expanded (
          flex: 1,
          child: Text(""),
        ),
        Expanded (
          flex: 8,
          child: Text(getContactDescription(widget.contact)),
        ),
        Expanded (
          flex: 2,
          child: IconButton(
            icon: const Icon(Icons.message, size: 25.0),
            onPressed: () {
              print("Pressed message button");
            },
          ),
        ),
        Expanded (
          flex: 2,
          child: IconButton(
            icon: const Icon(Icons.call, size: 25.0),
            onPressed: () {
              print("Pressed call button");
            },
          ),
        ),
        Expanded (
          flex: 2,
          child: 
          IconButton(
            icon: const Icon(Icons.more_horiz, size: 25.0),
            onPressed: () {
              print("Pressed settings button");
            },
          ),
        ),
      ],
    );
  }
}