import 'package:flutter/material.dart';
import '../utils/global.dart';

PreferredSizeWidget appBar({required String title}) =>
    AppBar(centerTitle: true,
        backgroundColor: appBarBackgroundColor, elevation: 0,title: Text(title,style: const TextStyle(fontWeight: FontWeight.bold),));