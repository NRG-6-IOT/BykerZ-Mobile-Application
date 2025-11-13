import 'package:byker_z_mobile/iam/bloc/authentication/authentication_bloc.dart';
import 'package:byker_z_mobile/iam/bloc/authentication/authentication_event.dart';
import 'package:byker_z_mobile/iam/bloc/authentication/authentication_state.dart';
import 'package:byker_z_mobile/iam/presentation/pages/sign-up_page.dart';
import 'package:byker_z_mobile/iam/services/authentication_service.dart';
import 'package:byker_z_mobile/iam/services/profile_service.dart';
import 'package:byker_z_mobile/shared/presentation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/profile/profile_bloc.dart';
import '../../models/sign-in_request.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInState();
}

class _SignInState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hasMechanic = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handlePostSignIn() async {
    final profileService = ProfileService();
    try {
      final response = await profileService.getProfile();
      if (!mounted) return;
      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => ProfileBloc(profileService: ProfileService()),
              child: const Dashboard(),
            ),
          ),
        );
      } else {
        // If the profile retrieval fails, do nothing?
      }
    } catch (e) {
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(
          authenticationService: AuthenticationService(),
          profileService: ProfileService()
      ),
      child: Scaffold(
        body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              _handlePostSignIn();
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'BykerZ',
                    style: const TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF481C0D),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      'images/bykerz.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'Username',
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFFF3F3F3),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.grey),
                      filled: true,
                      fillColor: Color(0xFFF3F3F3),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (state is AuthenticationFailure)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AuthenticationLoading
                          ? null
                          : () {
                        context.read<AuthenticationBloc>().add(
                          SignInEvent(
                            request: SignInRequest(
                              username: _usernameController.text,
                              password: _passwordController.text
                            )
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            const Color(0xFFFF6B35)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: state is AuthenticationLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Builder(
                      builder: (context) => ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<AuthenticationBloc>(),
                                child: const SignUpPage(),
                              ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              const Color(0xFFFFFFFF)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
