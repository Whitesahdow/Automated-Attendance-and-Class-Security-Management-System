import 'dart:convert';
import 'package:AAMCS_App/Student/user_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InstructorProfile extends StatefulWidget {
  const InstructorProfile(
      {Key? key,
      required String first_name,
      required String last_name,
      required String email,
      required String id})
      : super(key: key);
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<InstructorProfile> {
  late Future<user_info> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = getdata();
  }

  Future<user_info> getdata() async {
    final response = await http.get(Uri.parse("https://reqres.in/api/users/2"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final user = user_info(
        first_name: data['first_name'],
        last_name: data['last_name'],
        email: data['email'],
        id: data['id'].toString(),
      );
      return user;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 170, 163, 163),
      ),
      body: FutureBuilder<user_info>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: Cant find anything'));
          } else {
            final user = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${user.first_name} ${user.last_name}'),
                  Text('Email: ${user.email}'),
                  Text('id: ${user.id} '),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
