import 'dart:convert';
import 'package:AAMCS_App/Student/stu_Drawer/user_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentProfile extends StatefulWidget {
  const StudentProfile(
      {super.key,
      required String first_name,
      required String last_name,
      required String email,
      required String id});
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: Cant find anything'));
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

/*
body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 20.0),

            Text("Name: $firstName $middleName $lastName",
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Gender: $gender',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Student ID: $studentId',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Email: $email',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Department: $department',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Batch Section: $batchSection'),
          ],
        )
        )
*/
