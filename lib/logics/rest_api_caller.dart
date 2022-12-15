import 'dart:convert';
import 'dart:io';

import 'package:twalk_app/constants/constants.dart' as constants;
import 'package:http/http.dart' as http;

class RestApiCaller {
  static const serverHost = constants.serverHost;

  static putMethod(List<String> paths_, Map<String, String> parameters) async {
    String paths = paths2path(paths_);
    final uri = Uri.http(serverHost, paths);
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: parameters,
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> body = jsonDecode(responseBody);
      return body;
    }
    throw 'PUT METHOD ERROR';
  }

  static getMethod(List<String> paths_) async {
    String paths = paths2path(paths_);

    final uri = Uri.http(serverHost, paths);
    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (200 <= response.statusCode && response.statusCode < 300) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> body = jsonDecode(responseBody);
      return body;
    }
    throw 'GET METHOD ERROR';
  }

  static postMethod(List<String> paths_, Map<String, String> parameters) async {
    String paths = paths2path(paths_);
    final uri = Uri.http(serverHost, paths);
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: parameters,
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> body = jsonDecode(responseBody);
      return body;
    }
    throw 'POST METHOD ERROR';
  }

  static String paths2path(List<String> paths_) {
    String paths = "";
    for (var path in paths_) {
      paths += "/$path";
    }
    return paths;
  }
}
