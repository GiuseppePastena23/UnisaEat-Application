import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_cubit.dart';
import 'package:unisa_eat_2/presentation/home/bloc/qr_code_state.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.qr_code_2)),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text('Good Morning, John', style: Theme.of(context).textTheme.headlineMedium,)
          ],
        ),
      )
    );
  }
}
