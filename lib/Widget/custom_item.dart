import 'package:flutter/material.dart';
import 'package:to_do_app/cubit/cubit.dart';

Widget customItem(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(
  
        padding: const EdgeInsets.all(20.0),
  
        child: Row(
  
          children: [
  
            CircleAvatar(
  
              radius: 40,
  
              child: Text(
  
                '${model['time']}',
  
                style: TextStyle(
  
                  fontWeight: FontWeight.bold,
  
                  fontSize: 15,
  
                ),
  
              ),
  
            ),
  
            SizedBox(
  
              width: 20,
  
            ),
  
            Expanded(
  
              child: Column(
  
                mainAxisSize: MainAxisSize.min,
  
                children: [
  
                  Text(
  
                    '${model['title']}',
  
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  
                  ),
  
                  Text(
  
                    '${model['date']}',
  
                    style: TextStyle(color: Colors.grey),
  
                  ),
  
                ],
  
              ),
  
            ),
  
            SizedBox(
  
              width: 20,
  
            ),
  
            IconButton(
  
                icon: Icon(Icons.check_box_outlined,color: Colors.green,),
  
                onPressed: (){
  
                 AppCubit.get(context).updateDataBase(
  
                     states: 'done',
  
                     id: model['id']);
  
                }),
  
            IconButton(
  
                icon: Icon(Icons.archive,color: Colors.black38,),
  
                onPressed: (){
  
                  AppCubit.get(context).updateDataBase(
  
                      states: 'archive',
  
                      id: model['id']);
  
                })
  
          ],
  
        ),
  
      ),
  onDismissed: (direction){
    AppCubit.get(context).deletDataBase(id: model['id']);

  },
);
