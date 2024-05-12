import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthController {
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  Future loginuser() async {
    // Check if username or password is empty
    if (username_controller.text.isEmpty || password_controller.text.isEmpty) {
      print("Error: Username or password is empty");
    }

    const url = "https://reqres.in/api/login";
    try {
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "email": username_controller.text,
          "password": password_controller.text,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var loginArr = jsonDecode(response.body);
        print(loginArr.toString());
      } else {
        print("Error : ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
