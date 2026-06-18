import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/auth/models/log_in_params.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_cubit.dart';

import 'package:unisa_eat_2/presentation/shared/bloc/user_profile_cubit.dart';
import 'package:unisa_eat_2/presentation/wallet/bloc/wallet_cubit.dart';

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

  String _getErrorMessage(ApiError error, AppLocalizations l10n) {
    switch (error.type) {
      case ErrorType.network:
        return l10n.error_network;
      case ErrorType.server:
        return l10n.error_server;
      case ErrorType.auth:
        return l10n.error_auth;
      case ErrorType.validation:
        return l10n.error_validation;
      case ErrorType.balance:
        return l10n.error_balance;
      case ErrorType.unknown:
        return l10n.error_unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (BuildContext context, state) {
          if (state is LoginFailure) {
            final l10n = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_getErrorMessage(state.error, l10n))),
            );
           } else if (state is LoginSuccess) {
             context.read<UserProfileCubit>().getUser(forceRefresh: true);
             context.read<WalletCubit>().getData();
             context.go('/home');
           }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
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
              if (state is LoginLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
        ),
      );
  }

  Widget _loginButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(l10n.login_title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _loginText() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.restaurant_menu,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'UnisaEat',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.login_title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _emailField() {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: l10n.email_label,
        prefixIcon: const Icon(Icons.email_outlined),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return l10n.field_required;
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        if (!emailRegex.hasMatch(value.trim())) return l10n.email_invalid;
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
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.isEmpty ? l10n.field_required : null,
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
        text: '${l10n.dont_have_account} ',
        children: [
          TextSpan(
            text: l10n.sign_up,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap=(){
              context.go('/signup');
            }
          )
        ]
      )
    );
  }
}
