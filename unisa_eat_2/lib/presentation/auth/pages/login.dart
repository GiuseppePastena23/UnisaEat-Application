import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_cubit.dart';

import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (BuildContext context, state) {
          if (state is LoginLoading) {
            // Show loading dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is LoginFailure) {
            // Dismiss loading dialog if present
            if (ModalRoute.of(context)?.canPop ?? false) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.message)),
            );
           } else if (state is LoginSuccess) {
            // Dismiss loading dialog if present
            if (ModalRoute.of(context)?.canPop ?? false) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            // Refresh user profile data
            context.read<UserProfileCubit>().getUser(forceRefresh: true);
            context.go('/home');
            context.read<UserProfileCubit>().getUser();
          }
        },
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 0, right: 30, left: 30, bottom: 0),
          child: Center(
            child: Form(
              key: _formKey,
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
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: 200,
      height: 50,

      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<LoginCubit>().login(
              LogInParams(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
        )),

        child: Text(l10n.login_title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
    );
  }

  Widget _loginText() {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.login_title,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _emailField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: l10n.email_label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Enter email';
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
        return null;
      },
    );
  }

  Widget _passwordField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      obscureText: !_passwordVisible,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: l10n.password_label,
        border: OutlineInputBorder(),

      ),
      validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
    );
  }

  Widget _showPasswordCheckbox() {
    final l10n = AppLocalizations.of(context)!;
    return CheckboxListTile(

      contentPadding: EdgeInsets.zero,
      title: Text(l10n.show_password),
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
    final l10n = AppLocalizations.of(context)!;
    return Text.rich(
      TextSpan(
        text: l10n.dont_have_account,
        children: [
          TextSpan(

            text: l10n.sign_up,

            recognizer: TapGestureRecognizer()..onTap=(){
              context.go('/signup');
            }

          )
        ]
      )
    );
  }
}
