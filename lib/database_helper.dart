import 'dart:io';                                   // Used for Directory support
import 'package:sqflite/sqflite.dart';              // User for SQLite support
import 'package:path_provider/path_provider.dart';  // Used for GetApplicationDocumentsDirectory support
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';                    // Used for join support

import 'contact_model.dart';                         // Our Contact Model

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
      CREATE TABLE IF NOT EXISTS contacts (
        id INTEGER PRIMARY KEY,
        number TEXT NOT NULL,
        firstname TEXT,
        lastname TEXT,
        email TEXT,
        birthDate TEXT
      )''');
  }

  Future<List<Contact>> getContacts() async {

    Database db = await instance.database;
    var contacts = await db.query('contacts', orderBy: 'number');

    List<Contact> contactList = contacts.isEmpty ? [] : contacts.map((e) => Contact.fromObject(e)).toList();
    return contactList;
  }

  Future<int> add(Contact contact) async {
    Database db = await instance.database;
    return await db.insert('contacts', contact.toObject());
  }

  Future<int> update(Contact contact) async {
    Database db = await instance.database;
    return db.update('contacts', contact.toObject(), where: 'id = ?', whereArgs: [contact.id]);
  }

  Future<int> delete(Contact contact) async {
    Database db = await instance.database;
    return db.delete('contacts', where: 'id = ?', whereArgs: [contact.id]);
  }
}