



import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/components/constant.dart';
import 'package:to_do_app/cubit/states.dart';
import 'package:to_do_app/modules/archive_task_screen.dart';
import 'package:to_do_app/modules/done_task_screen.dart';
import 'package:to_do_app/modules/task_screen.dart';

class AppCubit extends Cubit<AppState>{
  //you should to create empty constractor
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

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

  void changeIndexNavBar(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }

  Database database;
  List <Map> newTasks=[];
  List <Map> doneTasks=[];
  List <Map> archiveTasks=[];

  void createDataBase() {
     openDatabase( //   عملتها await عشان بتدني Future
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

        onOpen: (database)
        {
          this.database=database;
          print('database opened');
          getDataFromDataBase(database);
        }

    ).then((value) {
      emit(AppCreateDataBaseState());
     });
  }

  insertToDataBase({
    @required String title,
    @required String time,
    @required String date
  })async
  {
    await database.transaction((txn){
      txn.rawInsert(
          'INSERT INTO tasks(title , date , time , states) Values ("$title" , "$date" , "$time" , " new")'
      ).then((value){

        print('$value inserted successfully');
        emit(AppInsertDataBaseState());

        getDataFromDataBase(database);

      }).catchError((error){
        print('error when inserted is ${error.toString()}');
      });

      return null;
    });
  }

  void getDataFromDataBase(database){
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];
     database.rawQuery('Select * From tasks').then((value){
//       tasks=value;
//       print(tasks);
       value.forEach((element) {
         if(element['states']==' new')
           newTasks.add(element);
         else  if(element['states']=='done')
           doneTasks.add(element);
         else
           archiveTasks.add(element);
        // print(element['states']);
       });

       emit(AppGetDatabaseState());
     });
  }

  void updateDataBase({
  @required String states,
  @required int id
}) async{ //update to state by id

    database.rawUpdate(
        'UPDATE tasks SET states = ? WHERE id = ?',
        ['$states', id]
    ).then((value){
      getDataFromDataBase(database); // here will add ,you should in get method task 0 ,done 0, archive 0
      emit(AppUpdateDatabaseState());
    });

  }

  void deletDataBase({
    @required int id
  }) async{ //update to state by id

    database.rawDelete(
        'DELETE from tasks WHERE id = ?',
        [id]
    ).then((value){
      getDataFromDataBase(database); // here will add ,you should in get method task 0 ,done 0, archive 0
      emit(AppDeleteDatabaseState());
    });

  }




  IconData febIcon = Icons.edit;
  bool isBottomSheetShown =false;

  void changeBottomSheet({
    @required bool isShow,
    @required IconData icon,

  }){
    isBottomSheetShown=isShow;
    febIcon=icon;
    emit(AppChangeBottomSheetState());


  }

}