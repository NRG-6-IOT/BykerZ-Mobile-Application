import 'package:byker_z_mobile/iam/models/sign-in_response.dart';
import 'package:byker_z_mobile/iam/models/sign-up_response.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class SignInSuccess extends AuthenticationState {
  final SignInResponse response;

  SignInSuccess(this.response);
}

class SignUpSuccess extends AuthenticationState {
  final SignUpResponse response;

  SignUpSuccess(this.response);
}

class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure(this.error);
}