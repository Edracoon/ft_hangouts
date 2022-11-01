import 'package:flutter/material.dart';
import 'package:ft_hangouts/contact_model.dart';

class ResumeContact extends StatefulWidget {

  final Contact contact;

  const ResumeContact({Key? key, required this.contact}) : super(key: key);

  @override
  State<ResumeContact> createState() => _ResumeContactState();
}

class _ResumeContactState extends State<ResumeContact> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded (
          flex: 1,
          child: Icon(Icons.person, size: 35.0),
        ),
        const Expanded (
          flex: 1,
          child: Text(" "),
        ),
        Expanded (
          flex: 6,
          child: Text(widget.contact.firstname == "" && widget.contact.lastname == "" ? widget.contact.number :  "${widget.contact.firstname} ${widget.contact.lastname}"),
        ),
        Expanded (
          flex: 2,
          child: IconButton(
            icon: const Icon(Icons.message, size: 20.0),
            onPressed: () {
              print("Pressed message button");
            },
          ),
        ),
        Expanded (
          flex: 2,
          child: IconButton(
            icon: const Icon(Icons.call, size: 20.0),
            onPressed: () {
              print("Pressed call button");
            },
          ),
        ),
        Expanded (
          flex: 2,
          child: 
          IconButton(
            icon: const Icon(Icons.settings, size: 20.0),
            onPressed: () {
              print("Pressed settings button");
            },
          ),
        ),
      ],
    );
  }
}