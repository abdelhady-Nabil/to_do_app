import 'package:flutter/material.dart';

Widget customItem(Map model)=>Padding(
padding: const EdgeInsets.all(20.0),
child: Row(
children: [
CircleAvatar(
radius: 40,
child: Text('${model['time']}',style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 15,
),),

),
SizedBox(
width: 20,
),
Column(
mainAxisSize: MainAxisSize.min,

children: [
Text('${model['title']}',style: TextStyle(

fontSize: 16,
fontWeight: FontWeight.bold
),),
Text('${model['date']}',style: TextStyle(
color: Colors.grey
),),
],
),
],
),
);
