import 'package:byker_z_mobile/iam/bloc/authentication/authentication_bloc.dart';
import 'package:byker_z_mobile/iam/presentation/pages/sign-in.page.dart';
import 'package:byker_z_mobile/iam/services/authentication_service.dart';
import 'package:byker_z_mobile/iam/services/profile_service.dart';
import 'package:byker_z_mobile/maintenance_and_operations/presentation/pages/expense_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthenticationBloc(
            authenticationService: AuthenticationService(),
            profileService: ProfileService()
          )
        ),
      ],
      child: MaterialApp(
        title: 'BykerZ',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SignInPage(),
        onGenerateRoute: (settings) {
          // Handle /expense-details route with arguments
          if (settings.name == '/expense-details') {
            final expenseId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (context) => ExpenseDetail(expenseId: expenseId),
            );
          }
          // Return null for unknown routes (will show error)
          return null;
        },
      )
    );
  }
}
