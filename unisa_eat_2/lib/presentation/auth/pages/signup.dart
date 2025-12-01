import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


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
            
            recognizer: TapGestureRecognizer()..onTap=(){
              
            }
            
          )
        ]
      )
    );
  }
  
}
