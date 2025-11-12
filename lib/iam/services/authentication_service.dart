import 'package:byker_z_mobile/shared/client/api.client.dart';
import 'package:http/http.dart' as http;

import '../models/sign-in_request.dart';
import '../models/sign-up_request.dart';

class AuthenticationService {
  Future<http.Response> signIn(SignInRequest request) async {
    return await ApiClient.post('authentication/sign-in', body: request.toJson());
  }

  Future<http.Response> signUp(SignUpRequest request) async {
    return await ApiClient.post('authentication/sign-up', body: request.toJson(),);
  }
}