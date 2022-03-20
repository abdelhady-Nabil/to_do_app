import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Widget/custom_text_form_field.dart';
import 'components/constant.dart';
import 'modules/archive_task_screen.dart';
import 'modules/done_task_screen.dart';
import 'modules/task_screen.dart';
import 'package:sqflite/sqflite.dart';

main(){
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int index = 0;

  Database database;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var scaffoldKey =GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var febIcon = Icons.edit;
  TextEditingController titleController=TextEditingController();
  TextEditingController timeController=TextEditingController();
  TextEditingController dateController=TextEditingController();


  bool isBottomSheetShown =false;



  List<Widget>screens = [
    TaskScreen(),
    DoneTaskScreen(),
    ArchiveTaskScreen(),
  ];

  List<String>appBars =[
    'New Task',
    'Done Tasks',
    'Archive Tasks'

  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(appBars[index]),
        ),

        body: tasks.length == 0 ? Center(child: CircularProgressIndicator()) :screens[index],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          onTap: (index){
            setState(() {
              this.index=index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.menu),
              label: 'New Tasks'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.done),
                label: 'Done Tasks'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive),
                label: 'Archive Tasks'
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){

            if(isBottomSheetShown){
              if(formKey.currentState.validate()){
                insertToDataBase(
                  title: titleController.text,
                  time: timeController.text,
                  date: dateController.text,
                ).then((value){
                  isBottomSheetShown=!isBottomSheetShown;
                  Navigator.of(scaffoldKey.currentContext).pop();
                  setState(() {
                    febIcon=Icons.edit;
                  });

                }).catchError((error){
                  print('error when insert data');

                });

              }
              }

            else{
              scaffoldKey.currentState.showBottomSheet(

                    (context) => Container(
                      color: Colors.white,


                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextFormField(
                          controller: titleController,
                          prefixIcon: Icons.title,
                          label: 'Text Title',
                          inputType: TextInputType.text,
                          hintText: 'Text Title',
                          validator: (value){
                            if(value.isEmpty){
                              //print('title must not empty');
                              return 'title must not empty';
                            }
                            return null;
                          },



                        ),
                        CustomTextFormField(
                          controller: timeController,
                          prefixIcon: Icons.watch_later_outlined,
                          label: 'Text Time',
                          inputType: TextInputType.datetime,
                          hintText: 'Text Time',
                          validator: (value){
                            if(value.isEmpty){
                              //print('time must not empty');
                              return 'time must not empty';
                            }
                            return null;
                          },
                          onTap: (){
                            showTimePicker( //future
                                context: context,
                                initialTime: TimeOfDay.now()
                            ).then((value){
                              timeController.text = value.format(context).toString();
                              print(value.format(context));
                            }).catchError((error){
                              print('Time error is  ${error.toString()}');
                            });


                          },



                        ),
                        CustomTextFormField(
                          controller: dateController,
                          prefixIcon: Icons.date_range_outlined,
                          label: 'Text Date',
                          inputType: TextInputType.datetime,
                          hintText: 'Text Date',
                          validator: (value){
                            if(value.isEmpty){
                             // print('Date must not empty');
                              return 'Date must not empty';
                            }
                            return null;
                          },
                          onTap: (){
                            showDatePicker(
                                context: (context),
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2022-04-01')
                            ).then((value){
                              dateController.text= DateFormat.yMMMd().format(value);
                              print(DateFormat.yMMMd().format(value));
                            }).catchError((error){
                              print('$error error when show date picker');
                            });
                          },



                        ),

                      ],
                    ),
                  ),
                ),
                    elevation: 15,
              ).closed.then((value){
                isBottomSheetShown=!isBottomSheetShown;
                setState(() {
                  febIcon=Icons.edit;
                });
              })
              ;
              isBottomSheetShown=!isBottomSheetShown;

              setState(() {
                febIcon=Icons.add;
              });

            }


          },
          child: Icon(febIcon),
        ),
      ),
    );
  }
  void createDataBase() async{
     database = await openDatabase( //   عملتها await عشان بتدني Future
      'todo.db' ,
    version: 1,
      onCreate: (database , version){
        print('data base is created');

        database.execute(
            'Create table tasks (id integer primary key , title text , date text , time text , states text)'
        ).then((value){
          print('The table is created');
        }).catchError((error){
          print('the error is ${error.toString()}');
        });
      },

      onOpen: (database){
        print('database opened');
        getDataFromDataBase(database).then((value){
          tasks=value;
          print(tasks);
        });
    }

    );
  }

  Future insertToDataBase({
    @required String title,
    @required String time,
    @required String date
  }) async{

    return await database.transaction((txn){
       txn.rawInsert(
         'insert into tasks(title , date , time , states) Values ("$title" , "$date" , "$time" , " new")'
       ).then((value){
         print('$value inserted successfully');
       }).catchError((error){
         print('error when inserted is ${error.toString()}');
       });


       return null;
    });
  }

  Future<List<Map>> getDataFromDataBase(database)async{
     return await database.rawQuery('Select * From tasks');
  }
}




