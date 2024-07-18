import 'package:flutter/material.dart';
import '../utils/global.dart';

PreferredSizeWidget appBar({required String title}) =>
    AppBar(backgroundColor: appBarBackgroundColor, elevation: 0,title: Text(title,style: TextStyle(fontWeight: FontWeight.bold),));