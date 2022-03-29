import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Widget/custom_conditional_builder.dart';
import 'package:to_do_app/Widget/custom_item.dart';
import 'package:to_do_app/components/constant.dart';
import 'package:to_do_app/cubit/cubit.dart';
import 'package:to_do_app/cubit/states.dart';
class ArchiveTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
      listener: (context,state){},
      builder: (context,state){
        var tasks = AppCubit.get(context).archiveTasks;
        return customConditional(tasks: tasks);
      },

    );
  }
}
