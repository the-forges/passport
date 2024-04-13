import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path_helper;

class Authentication {
  const Authentication({required this.url});
  final String url;

  Future<AuthenticationResponse> authenticate() async {
    final applicationsDir = await getApplicationDocumentsDirectory();
    final publicKeyPath = path_helper.join(applicationsDir.path, 'master.pub');
    final publicKey = File(publicKeyPath);
    if (!publicKey.existsSync()) {
      return const AuthenticationResponse(error: "missing master key");
    }

    log("url: $url");
    log("public_key: ${publicKey.readAsStringSync()}");
    final dio = Dio();
    final response = await dio.post(url, data: {"public_key": publicKey.readAsStringSync()});
    log("response: ${response.data}");
    return const AuthenticationResponse();
  }
}

class AuthenticationResponse {
  const AuthenticationResponse({this.error, this.user});
  final String? error;
  final User? user;
}

class User {
  String? displayName;
}