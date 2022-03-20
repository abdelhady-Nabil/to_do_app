import 'package:flutter/material.dart';
import 'package:to_do_app/Widget/custom_item.dart';
import 'package:to_do_app/components/constant.dart';
class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context,index) => customItem(tasks[index]),
        separatorBuilder: (context,index) => Container(
          margin: EdgeInsets.only(left: 20),
          width: double.infinity,
          height: 1,
          color: Colors.grey[300],
        ),
        itemCount: tasks.length);
  }
}
