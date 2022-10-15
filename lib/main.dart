import 'dart:io'; // Used for Directory support
import 'dart:math';
import 'package:sqflite/sqflite.dart'; // User for SQLite support
import 'package:path_provider/path_provider.dart'; // Used for GetApplicationDocumentsDirectory support
import 'package:path/path.dart'; // Used for join support

import 'package:flutter/material.dart'; // Flutter global import

void main() {
  runApp( const MyApp() );
}

Color randomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool typing = false;
  final searchCtrl = TextEditingController();
  final focusTitle = FocusNode();

  void toggleType() {
    typing = !typing;
    if (typing == true) {
      focusTitle.requestFocus();
    }
    else { searchCtrl.text = ""; }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
        body: SizedBox.expand(
          child: GestureDetector(
            onTap: () {
              setState(() {
                typing = false;
                searchCtrl.text = "";
              });
            },
            child: Container(
              color: Colors.deepPurple[400],
            ),
          )
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          hoverColor: Colors.deepPurple.shade600,
          child: const Icon(Icons.add),
          onPressed: () {
            print(searchCtrl.text);
          },
        ),
      ),
    );
  }
}

class Contact {
  final int?    id;
  final String  number;
  final String  firstname;
  final String  fullname;
  final String  email;

  Contact({this.id, this.firstname = "", this.fullname = "", required this.number, this.email = ""});

  factory Contact.fromMap(Map<String, dynamic> json) => Contact(
    id: json['id'],
    number: json['number'],
    firstname: json['firstname'],
    fullname: json['fullname'],
    email: json['email']
  );
}

class DatabaseHelper {
  // It create an interface where _database is
  // accessible via instance.database using the getter
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // SQLite object Database
  static Database? _database;

  // Getter of _database, if database is not created yet it launch initDatabase
  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database>  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();  // path_provider function
    String path = join(documentsDirectory.path, 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Script on create where we can init tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY,
        number TEXT NOT NULL,
        firstname TEXT DEFAUlT '',
        fullname TEXT DEFAULT '',
        email TEXT DEFAULT ''
      )
    ''');
  }

  Future<List<Contact>> getContacts() async {

    Database db = await instance.database;
    var contacts = await db.query('contacts', orderBy: 'number');

    List<Contact> contactList = contacts.isEmpty ? [] : 
      contacts.map((e) => Contact.fromMap(e)).toList();
  }

}