import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginResponse {
  String? token;
  String? loginArr;

  LoginResponse({this.token, this.loginArr});
}

class AuthController {
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  LoginResponse reuest_responese = LoginResponse();
  // AuthController({this.bodyreturn, this.loginArr});
  Future<String?> loginuser(String usertype) async {
    if (username_controller.text.isEmpty || password_controller.text.isEmpty) {
      print("Error: Username or password is empty");
      return null;
    }

    const url_base = "https://besufikadyilma.tech/";
    const url_inst = "instructor/auth/login";
    const url_stu = "student/auth/login";
    var urlFinal;
    usertype == 'teacher'
        ? urlFinal = url_base + url_inst
        : urlFinal = url_base + url_stu;

    try {
      var response = await http.post(
        Uri.parse(urlFinal),
        body: jsonEncode({
          "email": username_controller.text,
          "password": password_controller.text,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var Login_status = jsonDecode(response.body);
        var cookie = response.headers["set-cookie"].toString();

        print(
            " With out spliting...................................######################################## : $cookie");
        // var split = reuest_responese.token;
        String? splits = cookie.split("=")[1];
        splits = splits.split(";")[0];
        reuest_responese.loginArr = Login_status['msg'].toString();
        // print(
        //     " the message body  is...................................######################################## : $Login_status");
        String token_response = splits.toString();
        //bodyreturn = Login_status.toString();
        print("after splitting ${token_response}");

        // splits = reuest_responese.token;
        return splits;
      } else {
        print("Error : ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}

/*

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthController {
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  var my_Token = null;
  Future<String?> loginuser(var usertype) async {
    // Check if username or password is empty
    if (username_controller.text.isEmpty || password_controller.text.isEmpty) {
      print("Error: Username or password is empty");
    }
    const url_base = "https://besufikadyilma.tech/";
    const url_inst = "instructor/auth/login";
    const url_stu = "student/auth/login";
    var urlFinal;
    usertype == 'teacher'
        ? urlFinal = url_base + url_inst
        : urlFinal = url_base + url_stu;

    try {
      var response = await http.post(
        Uri.parse(urlFinal),
        body: jsonEncode({
          "email": username_controller.text,
          "password": password_controller.text,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        my_Token = jsonDecode(response.body); // need to store the token
        var loginArr = response.headers["set-cookie"].toString();
        loginArr = loginArr.split("=")[1];
        loginArr = loginArr.split(";")[0];

        print(loginArr.runtimeType);
        my_Token = my_Token['msg'].toString();
        // print(my_Token.runtimeType);
        print(
            " the Token is...................................######################################## : $loginArr");
      
        // username_controller.dispose();
        // password_controller.dispose();

        return my_Token;
      } else {
        print("Error : ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

/*
Map<String, dynamic> decodedToken = JwtDecoder.decode(my_Token);
        var email = decodedToken['email'];
*/ 
*/