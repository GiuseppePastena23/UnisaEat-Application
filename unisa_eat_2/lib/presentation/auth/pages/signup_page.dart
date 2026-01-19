import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:unisa_eat_2/data/auth/models/register_params.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _password2Controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _fiscalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful! Please login.')),
            );
            context.go('/login');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.message)),
            );
          }
        },
        child:         BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                     TextFormField(
                       controller: _emailController,
                       decoration: const InputDecoration(labelText: 'Email'),
                       validator: (value) {
                         if (value == null || value.trim().isEmpty) return 'Enter email';
                         final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                         if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
                         return null;
                       },
                     ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      validator: (value) => value!.isEmpty ? 'Enter first name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) => value!.isEmpty ? 'Enter last name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _fiscalCodeController,
                      decoration: const InputDecoration(labelText: 'Fiscal Code'),
                      validator: (value) => value!.isEmpty ? 'Enter fiscal code' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      validator: (value) => value!.isEmpty ? 'Enter phone' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) => value!.length < 8 ? 'Password too short' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _password2Controller,
                      decoration: const InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 32),
                    state is LoginLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _register,
                            child: const Text('Sign Up'),
                          ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Already have an account? Login'),
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
      );
      context.read<LoginCubit>().register(params);
    }
  }
}