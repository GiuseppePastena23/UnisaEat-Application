import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/core/models/api_error.dart';
import 'package:unisa_eat_2/data/auth/models/register_params.dart';
import 'package:unisa_eat_2/l10n/app_localizations.dart';
import 'package:unisa_eat_2/presentation/auth/bloc/login_cubit.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fiscalCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdateController = TextEditingController();
  
  bool _passwordVisible = false;
  bool _password2Visible = false;
  DateTime? _selectedBirthdate;

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fiscalCodeController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthdate() async {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: l10n.birthdate,
    );
    if (picked != null) {
      setState(() {
        _selectedBirthdate = picked;
        _birthdateController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  String? _validateEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.field_required;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) return l10n.email_invalid;
    return null;
  }

  String? _validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.field_required;
    if (value.length < 8) return l10n.password_too_short;
    return null;
  }

  String? _validatePassword2(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.field_required;
    if (value != _passwordController.text) return l10n.passwords_not_match;
    return null;
  }

  String? _validateRequired(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.field_required;
    return null;
  }

  String? _validatePhone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.field_required;
    final phoneRegex = RegExp(r'^\+?[0-9]{8,15}$');
    if (!phoneRegex.hasMatch(value.trim())) return l10n.phone_invalid;
    return null;
  }

  String? _validateFiscalCode(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.field_required;
    if (value.trim().length != 16) return l10n.fiscal_code_invalid;
    return null;
  }

  String? _validateBirthdate(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.birthdate_required;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
        title: Text(l10n.sign_up),
      ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration successful! Please login.')),
            );
            context.go('/login');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_getErrorMessage(state.error, l10n))),
            );
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.email_label,
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => _validateEmail(value, l10n),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'Nome',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: const OutlineInputBorder(),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => _validateRequired(value, l10n),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Cognome',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: const OutlineInputBorder(),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => _validateRequired(value, l10n),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _fiscalCodeController,
                      decoration: InputDecoration(
                        labelText: 'Codice Fiscale',
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => _validateFiscalCode(value, l10n),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Numero di telefono',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => _validatePhone(value, l10n),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _birthdateController,
                      readOnly: true,
                      onTap: _selectBirthdate,
                      decoration: InputDecoration(
                        labelText: l10n.birthdate,
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => _validateBirthdate(value, l10n),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: l10n.password_label,
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => _validatePassword(value, l10n),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password2Controller,
                      obscureText: !_password2Visible,
                      decoration: InputDecoration(
                        labelText: 'Conferma Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _password2Visible ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _password2Visible = !_password2Visible;
                            });
                          },
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => _validatePassword2(value, l10n),
                    ),
                    const SizedBox(height: 32),
                    state is LoginLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              l10n.sign_up,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.already_have_account),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            l10n.sign_up,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      final params = RegisterParams(
        email: _emailController.text,
        password: _passwordController.text,
        password2: _password2Controller.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        fiscalCode: _fiscalCodeController.text,
        phone: _phoneController.text,
        birthdate: _birthdateController.text,
      );
      context.read<LoginCubit>().register(params);
    }
  }
}
