import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telephony/telephony.dart';

import '../contact_model.dart';
import '../database_helper.dart';
import './resume_contact.dart';
import './header_color.dart';


// Defining what is the Callback type function that
// will triger my parent widget
typedef Callback = void Function(int redirectPage, Contact? contact);

class HomeContact extends StatefulWidget {
  // The callback variable
  final Callback callback;
  DateTime? dateInactive;
  MaterialAccentColor headerColor = headerColorGlobal.headerColor;

  // The constructor where we add the callback as required
  HomeContact({Key? key, required this.callback}) : super(key: key);

  @override
  State<HomeContact> createState() => _HomeContactState();
}

class _HomeContactState extends State<HomeContact> with WidgetsBindingObserver {

  bool typing = false;
  List<Contact> contacts = [];
  final searchCtrl = TextEditingController();
  final focusTitle = FocusNode();
  final Telephony telephony = Telephony.instance;

  void toggleType() {
    typing = !typing;
    if (typing == true) {  focusTitle.requestFocus(); }
    else { searchCtrl.text = ""; }
  }

  // Init the observer of the WidgetBindingObserver
  @override
  void initState() {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {
        String number = '${message.address}';
        RegExp exp = RegExp(r"\d{2}");
        Iterable<Match> matches = exp.allMatches(number);
        number = '0${matches.map((m) => int.tryParse(m.group(0)!)).join(' ')}';
        bool doContactExist = await DatabaseHelper.instance.findByNumber(number);
        if (doContactExist == false)
        {
          Contact newContact = Contact(number: number);
          setState(() {
            contacts.add(newContact);
          });
          DatabaseHelper.instance.add(newContact);
        }
      },
      listenInBackground: false,
    );

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }
  // Remove the observe when the dispose widget method is called
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive)
    {
      setState(() { widget.dateInactive = DateTime.now(); });
    }
    else if (state == AppLifecycleState.resumed && widget.dateInactive != null)
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${AppLocalizations.of(context).setInBackground} ${widget.dateInactive!.hour}:${widget.dateInactive!.minute}:${widget.dateInactive!.second >= 10 ? widget.dateInactive!.second : '0${widget.dateInactive!.second}'}.'),
        ));
      setState(() {
        widget.dateInactive = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.headerColor,
        title: typing ?
          TextField(
            focusNode: focusTitle,
            controller: searchCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(border: InputBorder.none, hintText: AppLocalizations.of(context).search, hintStyle: const TextStyle(color: Color.fromARGB(255, 224, 224, 224))),
          )
          :
          GestureDetector(
            onTap: () { setState(toggleType); },
            child: const Text("42 Hangouts")
          ),
        leading: IconButton(
          icon: Icon(typing ? Icons.cancel_outlined : Icons.search),
          onPressed: () { setState(toggleType); },
        ),
        actions: [
          PopupMenuButton(
            onSelected: (int value) {
              setState(() {
                widget.headerColor = headerColorGlobal.updateColor(value);
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 1, child: Text(AppLocalizations.of(context).blue)),
              PopupMenuItem(value: 2, child: Text(AppLocalizations.of(context).green)),
              PopupMenuItem(value: 3, child: Text(AppLocalizations.of(context).orange)),
              PopupMenuItem(value: 4, child: Text(AppLocalizations.of(context).purple)),
            ]
          )
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent, // Allow behind component to receiv the tap event so the onTap is fired
        onTap: () { setState(() { typing = false; }); },
        child: Center(
          child: FutureBuilder<List<Contact>>(
            future: DatabaseHelper.instance.getContacts(),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text(AppLocalizations.of(context).loading));
              }
              if (snapshot.data!.isEmpty) {
                return Center(child: Text(AppLocalizations.of(context).noContact));
              }
              contacts = snapshot.data!;
              return (ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Color.fromARGB(255, 42, 42, 42),
                      height: 10,
                      indent: 25,
                      endIndent: 25,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ResumeContact(callback: widget.callback, contact: snapshot.data![index]),
                    ),
                  )
              );
            }
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.headerColor,
        hoverColor: widget.headerColor,
        child: const Icon(Icons.add),
        onPressed: () { widget.callback(1, null); },
      ),
    );
  }
}