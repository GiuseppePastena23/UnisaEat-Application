import 'package:flutter/material.dart';
import 'package:unisa_eat_2/presentation/widget/profile_appbar.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileAppBar(),
      body: Center(
        child: Text(
          'Welcome to the Home Page',
          style: TextStyle(fontSize: 24),

        ),
      ),
    );
  }
}