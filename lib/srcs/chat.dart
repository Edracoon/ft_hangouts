import 'package:flutter/material.dart';

import 'package:telephony/telephony.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../contact_model.dart';
import '../header_color.dart';
import './message.dart';

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
  final messageFocus = FocusNode();

  List<SmsMessage> messages = [];

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
      body: Column(
        children: [
          createMessageList(),
          Form(child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      focusNode: messageFocus,
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).writeMessage,
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                        );
                        messageController.text = '';
                        messageFocus.unfocus();
                      }
                    },
                    backgroundColor: headerColorGlobal.headerColor,
                    elevation: 0,
                    child: const Icon(Icons.send,color: Colors.white, size: 25),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget createMessageList() {
    retrieveAllMessage();
    if (messages.isNotEmpty)
    {
      return (
        Flexible(
          child: ListView.builder(
            itemCount: messages.length,
            reverse: true,
            itemBuilder: (context, index) => Message(messages[index], widget.contact)
        ))
      );
    }
    else {
      return Center(
        child: Text(AppLocalizations.of(context).messagesEmpty),
      );
    }
  }

  void retrieveAllMessage() async {
    List<SmsMessage> temp = [];
    // Get messages sent by the contact
    temp = await telephony.getInboxSms(
      columns: [SmsColumn.TYPE, SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE, SmsColumn.TYPE],
      filter: SmsFilter.where(SmsColumn.ADDRESS).equals(widget.contact.number.split(' ').join('')),
      sortOrder: [OrderBy(SmsColumn.DATE_SENT)]
    );
    // Get messages that we sent to the contact
    temp += await telephony.getSentSms(
      columns: [SmsColumn.TYPE, SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE, SmsColumn.TYPE],
      filter: SmsFilter.where(SmsColumn.ADDRESS).equals(widget.contact.number.split(' ').join('')),
      sortOrder: [OrderBy(SmsColumn.DATE)]
    );
    // Sort the messages by date so they mix them up (Sent and Received)
    temp.sort((a, b) {
      DateTime m1Date = DateTime.fromMicrosecondsSinceEpoch(a.date! * 1000, isUtc: false).toLocal();
      DateTime m2Date = DateTime.fromMicrosecondsSinceEpoch(b.date! * 1000, isUtc: false).toLocal();
            
      return m2Date.compareTo(m1Date);
    });
    setState(() {
      messages = temp;
    });
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
}
