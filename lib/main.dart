import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp( const MyApp() );
}

Color randomColor() {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('42 Hangouts'),
        ),
        body: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              color: Colors.deepPurple.shade300,
              width: 450,
              height: 10,
            ),
            Container(
              color: Colors.deepPurple.shade400,
              width: 450,
              height: 10,
            ),
            Container(
              color: Colors.deepPurple.shade500,
              width: 450,
              height: 10,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          hoverColor: Colors.deepPurple.shade600,
          child: const Icon(Icons.add),
          onPressed: () {
            print('pressed !');
          },
        ),
      ),
    );
  }
}

class HelloWorld extends StatefulWidget {
  const HelloWorld({Key? key}) : super(key: key);

  @override
  State<HelloWorld> createState() => _HelloWorldState();
}

class _HelloWorldState extends State<HelloWorld> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}