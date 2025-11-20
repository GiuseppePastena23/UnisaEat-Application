import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:unisa_eat_2/common/helper/navigation/app_navigation.dart';
import 'package:unisa_eat_2/core/configs/theme/app_colors.dart';
import 'package:unisa_eat_2/presentation/auth/pages/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 0, right: 30, left: 30, bottom: 0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _signupText(),
              const SizedBox(height: 20),
              _emailField(),
              const SizedBox(height: 20),
              _passwordField(),
              _showPasswordCheckbox(),
              _loginText()
            ],
          ),
        ),
      ),
    );
  }

  Widget _signupText() {
    return const Text(
      'Sign Up',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryBlueLight,
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

  Widget _loginText() {
    return Text.rich(
      TextSpan(
        text: "Already Got an Account? ",
        children: [
          TextSpan(
            
            text: "Log In",
            style: TextStyle(
              color: AppColors.primaryBlueLight,
            ),
            recognizer: TapGestureRecognizer()..onTap=(){
              AppNavigation.push(context, LoginPage());
            }
            
          )
        ]
      )
    );
  }
  
}
