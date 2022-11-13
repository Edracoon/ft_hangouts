import 'package:flutter_localizations/flutter_localizations.dart';
// We could add this after the flutter gen-l10n command
// See this -> https://medium.com/@echolaojue/how-to-make-l10n-with-flutter-fd61e21e61d8
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart'; // Flutter global import
import 'package:ft_hangouts/contact_model.dart';
import 'package:ft_hangouts/srcs/chat_contact.dart';
import 'srcs/home_contact.dart';
import 'srcs/add_contact.dart';
import 'srcs/edit_contact.dart';
import 'srcs/chat_contact.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const MyApp() );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int           pageIndex = 0;
  late Contact  _selectedContact;

  void  onPageChange(int newIndex, Contact? selectedContact) {
    setState(() => pageIndex = newIndex);
    if (selectedContact != null) {
      setState(() => _selectedContact = selectedContact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '42 Hangouts',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black, fontSizeFactor: 1.1)
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      home: pageIndex == 0 ?
          HomeContact(callback: onPageChange)
          : pageIndex == 1 ? 
          AddContact(callback: onPageChange)
          : pageIndex == 2 ? 
          EditContact(callback: onPageChange, contact: _selectedContact)
          :
          Chat(callback: onPageChange, contact: _selectedContact),
    );
  }
}
