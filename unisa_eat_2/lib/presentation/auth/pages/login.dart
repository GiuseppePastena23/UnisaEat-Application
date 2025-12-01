import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_cubit.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_state.dart';

import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (BuildContext context, state) { 
          if (state is LoginFailure) {
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
            
          
          } else if (state is LoginSuccess) {
            
            context.go('/');
            context.read<UserProfileCubit>().getUser();
            Navigator.of(context, rootNavigator: true).pop();
            
          } else if (state is LoginLoading) {
            // Optionally show a loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(child: LoadingAnimationWidget.newtonCradle(color: AppColors.lightSecondaryAccent, size: 150));
              },
            );
          }
        },
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 0, right: 30, left: 30, bottom: 0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _loginText(),
                const SizedBox(height: 20),
                _emailField(),
                const SizedBox(height: 20),
                _passwordField(),
                _showPasswordCheckbox(),
                const SizedBox(height: 20),
                _loginButton(context),
                const SizedBox(height: 15),
                _signupText()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,

      child: ElevatedButton(
        onPressed: () {
          context.read<LoginCubit>().login(
            LogInParams(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
        )),
        
        child: Text('Login', style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _loginText() {
    return const Text(
      'Log In',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      obscureText: !_passwordVisible,
      controller: _passwordController,
      decoration: const InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        
      ),
    );
  }

  Widget _showPasswordCheckbox() {
    return CheckboxListTile(
      
      contentPadding: EdgeInsets.zero,
      title: const Text('Show Password'),
      value: _passwordVisible,
      onChanged: (newValue) {
        setState(() {
          _passwordVisible = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Widget _signupText() {
    return Text.rich(
      TextSpan(
        text: "Don't Have an Account? ",
        children: [
          TextSpan(
            
            text: "Sign Up",
           
            recognizer: TapGestureRecognizer()..onTap=(){
              
            }
            
          )
        ]
      )
    );
  }
}
