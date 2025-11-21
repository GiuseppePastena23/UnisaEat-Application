import 'package:flutter/material.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';

AppBar ProfileAppBar() {
  return AppBar(
    actions: [
      Text('Profile', style: TextStyle(color: Colors.white, fontSize: 16)),
      IconButton(
        icon: Icon(Icons.person, color: Colors.white),
        onPressed: () {
          // Handle profile icon press
        },
      ),
    ],
    title: Text(
      
      'Home Page',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: AppColors.primaryBlue,
    centerTitle: true,
  );
}
