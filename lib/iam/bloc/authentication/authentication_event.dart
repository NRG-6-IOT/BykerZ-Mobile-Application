import 'package:byker_z_mobile/iam/models/sign-in_request.dart';
import 'package:byker_z_mobile/iam/models/sign-up_request.dart';

abstract class AuthenticationEvent {}

class SignInEvent extends AuthenticationEvent {
  final SignInRequest request;

  SignInEvent({required this.request});
}

class SignUpEvent extends AuthenticationEvent {
  final SignUpRequest request;

  SignUpEvent({required this.request});
}

class SignOutEvent extends AuthenticationEvent {}

class ResetAuthenticationStateEvent extends AuthenticationEvent {}
