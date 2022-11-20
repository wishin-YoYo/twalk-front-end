import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:twalk_app/constants/constants.dart';
import 'dart:convert';

class UserStore extends ChangeNotifier {
  var id = 0;
  var userName = "Anonymous";

  update(int id) async {
    final response = await http.get(Uri.http(
      serverHost,
      "/api/v1/user/${id}",
    ));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      id = body["id"];
      userName = body["userName"];
    } else {
      // THROW EXCEPTION
    }
    notifyListeners();
  }
}
