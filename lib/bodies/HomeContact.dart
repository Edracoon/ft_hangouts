// ignore_for_file: file_names

import 'package:flutter/material.dart'; // Flutter global import
import '../ContactModel.dart';
import '../DatabaseHelper.dart';

// Defining what is the Callback type function that
// will triger my parent widget
typedef Callback = void Function(int redirectPage);

class HomeContact extends StatefulWidget {

  // The callback variable
  final Callback callback;

  // The constructor where we add the callback as required
  const HomeContact({Key? key, required this.callback}) : super(key: key);

  @override
  State<HomeContact> createState() => _HomeContactState();
}

class _HomeContactState extends State<HomeContact> {

  bool typing = false;
  final searchCtrl = TextEditingController();
  final focusTitle = FocusNode();

  void toggleType() {
    typing = !typing;
    if (typing == true) {  focusTitle.requestFocus(); }
    else { searchCtrl.text = ""; }
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
              return snapshot.data!.isEmpty
                ? const Center(child: Text('No contact yet !'),)
                : ListView(
                children: snapshot.data!.map((contact) {
                  return Center(
                    child: ListTile(
                      title: Text(contact.number),
                    )
                  );
                }).toList(),
              );
            }
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        hoverColor: Colors.deepPurple.shade600,
        child: const Icon(Icons.add),
        onPressed: () { widget.callback(1); },
      ),
    );
  }
}