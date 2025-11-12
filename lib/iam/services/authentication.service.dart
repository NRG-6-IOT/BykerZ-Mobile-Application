import 'package:http/http.dart' as http;

import '../models/sign-in.request.dart';
import '../models/sign-up.request.dart';

class AuthenticationService {
  Future<http.Response> signIn(SignInRequest request) async {
    return await ApiClient.post(
      'authentication/sign-in', body: request.toJson(),
    );
  }

  Future<http.Response> signUp(SignUpRequest request) async {
    return await ApiClient.post(
      'authentication/sign-up',
      body: request.toJson(),
    );
  }
}