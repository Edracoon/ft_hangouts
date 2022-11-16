import 'package:flutter/material.dart';

import 'package:telephony/telephony.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../contact_model.dart';
import './header_color.dart';
import './header_color.dart';

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
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerColorGlobal.headerColor,
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
              height: 70,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).writeMessage,
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  FloatingActionButton(
                    onPressed: () async {
                      bool? permSms = await telephony.requestSmsPermissions;
                      if (permSms != null && permSms && messageController.text.isNotEmpty) {
                        await telephony.sendSms(
                          to: contact.number,
                          message: messageController.text,
                          statusListener: _msgStatusListener
                        );
                        messageController.text = '';
                      }
                    },
                    backgroundColor: headerColorGlobal.headerColor,
                    elevation: 0,
                    child: const Icon(Icons.send,color: Colors.white, size: 25),
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

// Not used in our case
void  _msgStatusListener(SendStatus status) {
}