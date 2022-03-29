import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/cubit/cubit.dart';
import 'package:to_do_app/cubit/states.dart';

import 'Widget/custom_text_form_field.dart';
import 'components/constant.dart';
import 'components/shared_bloc_observer.dart';
import 'modules/archive_task_screen.dart';
import 'modules/done_task_screen.dart';
import 'modules/task_screen.dart';
import 'package:sqflite/sqflite.dart';

main(){
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {




  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var scaffoldKey =GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController=TextEditingController();
  TextEditingController timeController=TextEditingController();
  TextEditingController dateController=TextEditingController();


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: BlocProvider(
        create: (BuildContext context) => AppCubit()..createDataBase(),
        child: BlocConsumer<AppCubit,AppState>(
          listener: (BuildContext context,AppState state) {
            if(state is AppInsertDataBaseState){
              //Navigator.of(scaffoldKey.currentContext).pop();
              Navigator.pop(context);
            }
          },
          builder: (BuildContext context,AppState state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(cubit.appBars[cubit.currentIndex]),
              ),

              body:cubit.screens[cubit.currentIndex],

              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                type: BottomNavigationBarType.fixed,
                onTap: (index){
                  cubit.changeIndexNavBar(index);
//            setState(() {
//              this.index=index;
//            });
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

                  if(cubit.isBottomSheetShown){
                    if(formKey.currentState.validate())
                    {
                      cubit.insertToDataBase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text
                      );

//                      insertToDataBase(
//                        title: titleController.text,
//                        time: timeController.text,
//                        date: dateController.text,
//                      ).then((value){
                    //        getDataFromDatBase{
                      //           Navigator.of(scaffoldKey.currentContext).pop();

                      //        }
//
////                  setState(() {
                     // isBottomSheetShown=!isBottomSheetShown;
////                    febIcon=Icons.edit;
                    // task = value
////                  });
//
//                      }).catchError((error){
//                        print('error when insert data');
//
//                      });
//
                   }
                  }

                  else{
                    scaffoldKey.currentState.showBottomSheet
                      (

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
                      cubit.changeBottomSheet(
                        isShow: false,
                        icon: Icons.edit
                      );
//
                    });
                    cubit.changeBottomSheet(
                        isShow: true,
                        icon: Icons.add
                    );
                     //cubit.isBottomSheetShown=true;
      //              setState(() {
      //                febIcon=Icons.add;
      //              });

                  }


                },
                child: Icon(cubit.febIcon),
              ),
            );
          },

        )
      ),
    );
  }

}





