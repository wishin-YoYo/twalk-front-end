import 'dart:convert';
import 'dart:io';

import 'package:twalk_app/constants/constants.dart' as constants;
import 'package:http/http.dart' as http;

class RestApiCaller {
  static const serverHost = constants.serverHost;

  static getMethod(List<String> paths_) async {
    String paths = "";
    paths_.forEach((path) {
      paths += "/$path";
    });
    print("paths: " + paths);
    final uri = Uri.http(serverHost, paths);
    var response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      var body = jsonDecode(responseBody)["result"]["data"];
      return body;
    }
    throw 'GET METHOD ERROR';
  }

  static postMethod(Map<String, String> parameters) {}
}
