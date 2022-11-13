import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../contact_model.dart';
import '../database_helper.dart';
import './resume_contact.dart';

// Defining what is the Callback type function that
// will triger my parent widget
typedef Callback = void Function(int redirectPage, Contact? contact);

class HomeContact extends StatefulWidget {
  DateTime? dateInactive;

  // The callback variable
  final Callback callback;

  // The constructor where we add the callback as required
  HomeContact({Key? key, required this.callback}) : super(key: key);

  @override
  State<HomeContact> createState() => _HomeContactState();
}

class _HomeContactState extends State<HomeContact> with WidgetsBindingObserver {

  bool typing = false;
  final searchCtrl = TextEditingController();
  final focusTitle = FocusNode();

  void toggleType() {
    typing = !typing;
    if (typing == true) {  focusTitle.requestFocus(); }
    else { searchCtrl.text = ""; }
  }


  // Init the observer of the WidgetBindingObserver
  @override
  void initState() {
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
        backgroundColor: Colors.deepPurple,
        title: typing ?
          TextField(
            focusNode: focusTitle,
            controller: searchCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(border: InputBorder.none, hintText: 'Search', hintStyle: TextStyle(color: Color.fromARGB(255, 224, 224, 224))),
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
        actions: const [
          // PopupMenuButton(
          //   onSelected: (int value) {
          //     setState(() {
          //       widget.headerColor = headerColorGlobal.updateColor(value);
          //     });
          //   },
          //   itemBuilder: (context) => [
          //     PopupMenuItem(child: Text(AppLocalizations.of(context)!.redLabel), value: 1),
          //     PopupMenuItem(child: Text(AppLocalizations.of(context)!.blueLabel), value: 2,),
          //     PopupMenuItem(child: Text(AppLocalizations.of(context)!.yellowLabel), value: 3,),
          //     PopupMenuItem(child: Text(AppLocalizations.of(context)!.greenLabel), value: 4,),
          //     PopupMenuItem(child: Text(AppLocalizations.of(context)!.orangeLabel), value: 5,),
          //     PopupMenuItem(child: Text(AppLocalizations.of(context)!.purpleLabel), value: 6,),
          //     PopupMenuItem(child: Text(AppLocalizations.of(context)!.pinkLabel), value: 7,)
          //   ]
          // )
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
                return const Center(child: Text('Loading...'));
              }
              return (snapshot.data!.isEmpty
                ? const Center(child: Text('No contact yet !'))
                : ListView.separated(
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
        backgroundColor: Colors.deepPurple,
        hoverColor: Colors.deepPurple.shade600,
        child: const Icon(Icons.add),
        onPressed: () { widget.callback(1, null); },
      ),
    );
  }
}