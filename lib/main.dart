import 'package:flutter/material.dart'; // Flutter global import
import 'srcs/home_contact.dart';
import 'srcs/add_contact.dart';

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

  int     pageIndex = 0;

  void  onPageChange(int newIndex) => setState(() => pageIndex = newIndex);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '42 Hangouts',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black, fontSizeFactor: 1.1)
      ),
      home: pageIndex == 0 ? HomeContact(callback: onPageChange) : AddContact(callback: onPageChange)
    );
  }
}
