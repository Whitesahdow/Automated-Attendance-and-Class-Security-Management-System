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

Future<String?> logoutUser(String usertype, String? Mytoken) async {
  const url_base = "https://besufikadyilma.tech/";
  const url_inst = "instructor/auth/logout";
  const url_stu = "student/auth/logout";
  var urlFinal;
  usertype == 'Teacher'
      ? urlFinal = url_base + url_inst
      : urlFinal = url_base + url_stu;

  try {
    var response = await http.post(
      Uri.parse(urlFinal),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${Mytoken}"
      },
    );

    if (response.statusCode == 200) {
      var Logout_status = jsonDecode(response.body);

      var logoutResponse = Logout_status['msg'].toString();
      print(
          "........................................................$logoutResponse");

      return logoutResponse;
    } else {
      print("Error : ${response.body}");
      return null;
    }
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
