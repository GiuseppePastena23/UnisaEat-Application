import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/shared/widget/bottom_nav_bar.dart';
import 'package:unisa_eat_2/presentation/shared/widget/profile_app_bar.dart';




class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      
      body: Center(
        child: Text('Home Page Content'),
      ),
    );
  }
}


