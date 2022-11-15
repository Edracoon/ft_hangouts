import 'package:flutter/material.dart';

import 'package:telephony/telephony.dart';
import '../contact_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// Defining what is the Callback type function that
// will triger my parent widget
typedef Callback = void Function(int redirectPage, Contact? contact);

class Chat extends StatefulWidget {

  // The callback variable
  final Callback callback;

  final Contact contact;

  const Chat({Key? key, required this.contact, required this.callback}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final Telephony telephony = Telephony.instance;

  late Contact contact;
  final scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(getContactDescription(contact)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {  widget.callback(0, null); },
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).writeMessage,
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){},
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(Icons.send,color: Colors.white,size: 18,),
                  ),
                ],
                
              ),
            ),
          ),
        ],
      )
    );
  }
}

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