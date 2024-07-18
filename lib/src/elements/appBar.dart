import 'package:flutter/material.dart';
import '../utils/global.dart';

PreferredSizeWidget appBar({required String title}) => AppBar(
    centerTitle: true,
    backgroundColor: appBarBackgroundColor,
    actions: [
      IconButton(onPressed: (){}, icon: Icon(Icons.wind_power_rounded,color: Colors.blue,))
    ],
    elevation: 0,
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ));
