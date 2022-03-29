import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

import 'custom_item.dart';


//codeeeee

Widget customConditional({
  @required List <Map>tasks
}){
  return ConditionalBuilder(
    condition: tasks.length>0,
    builder: (context)=>ListView.separated(
        itemBuilder: (context,index) => customItem(tasks[index],context),
        separatorBuilder: (context,index) => Container(
          margin: EdgeInsets.only(left: 20),
          width: double.infinity,
          height: 1,
          color: Colors.grey[300],
        ),
        itemCount: tasks.length),
    fallback: (context)=>Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,size: 90,color: Colors.grey,),
          Text('No Tasks yet ,please add some Tasks',style: TextStyle(
              fontSize: 20,
              color: Colors.grey
          ),)
        ],
      ),
    ),

  );
}
