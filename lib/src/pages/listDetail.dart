import 'package:bloc_yapisi/src/elements/addButton.dart';
import 'package:bloc_yapisi/src/elements/appBar.dart';
import 'package:flutter/material.dart';

class ListDetailScreen extends StatefulWidget {
  const ListDetailScreen({super.key});

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'LSTEDETAy'),
      body: Center(
        child: addButton(onPressed: (){print('Hello');}, title: 'L,ste detau'),
      ),
    );
  }
}
