import 'package:byker_z_mobile/iam/bloc/authentication/authentication_bloc.dart';
import 'package:byker_z_mobile/iam/bloc/authentication/authentication_event.dart';
import 'package:byker_z_mobile/iam/bloc/authentication/authentication_state.dart';
import 'package:byker_z_mobile/iam/models/sign-in_request.dart';
import 'package:byker_z_mobile/shared/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/sign-up_request.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController photoUrlController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    photoUrlController.dispose();
    passwordController.dispose();
    confPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp(BuildContext context) {
    if (passwordController.text != confPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Implement sign-up logic
    final request = SignUpRequest(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      username: usernameController.text,
      email: emailController.text,
      photoUrl: photoUrlController.text,
      password: passwordController.text,
    );

    context.read<AuthenticationBloc>().add(SignUpEvent(request: request));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AuthenticationBloc>(),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            context.read<AuthenticationBloc>().add(
              SignInEvent(
                request: SignInRequest(
                  username: usernameController.text,
                  password: passwordController.text
                ),
              ),
            );
          } else if (state is SignInSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>
              const Dashboard()),
            );
          } else if (state is AuthenticationFailure) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 60,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First name',
                            hintText: 'First name',
                            prefixIcon: const Icon(Icons.abc, color: Colors.grey),
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last name',
                            hintText: 'Last name',
                            prefixIcon: const Icon(Icons.abc, color: Colors.grey),
                            filled: true,
                            fillColor: const Color(0xFFF3F3F3),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Username',
                      prefixIcon: const Icon(Icons.person, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'E-mail',
                      prefixIcon: const Icon(Icons.mail, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: photoUrlController,
                    decoration: InputDecoration(
                      labelText: 'Profile picture URL',
                      hintText: 'URL',
                      prefixIcon: const Icon(Icons.link, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: confPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Repeat password',
                      hintText: 'Repeat password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading ? null : () => _handleSignUp(context),
                      child: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}
