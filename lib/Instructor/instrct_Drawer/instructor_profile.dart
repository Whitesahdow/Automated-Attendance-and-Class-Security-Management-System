import 'dart:convert';
import 'package:AAMCS_App/Student/stu_Drawer/user_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InstructorProfile extends StatefulWidget {
  final String? My_Token;
  const InstructorProfile(this.My_Token, {super.key});

  @override
  _InstructorProfileState createState() => _InstructorProfileState();
}

class _InstructorProfileState extends State<InstructorProfile> {
  late Future<Instructor_info> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = getdata();
  }

  Future<Instructor_info> getdata() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/instructor/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.My_Token}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = Instructor_info(
        first_name: data['first_name'],
        middle_name: data['middle_name'],
        last_name: data['last_name'],
        email: data['email'],
        department: data['department'],
        gender: data['gender'],
        qualification: data['qualification'],
        teacher_id: data['teacher_id'].toString(),
        id_key: data['id'],
      );
      return user;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshData() async {
    try {
      final newData = getdata();
      setState(() {
        _dataFuture = newData;
      });
      await newData; // Ensure the new future is awaited and exceptions are handled.
    } catch (e) {
      // Handle the error appropriately here
      print('Error refreshing data: $e');
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<Instructor_info>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 20),
                  const Center(child: Text('Error: Cannot find anything')),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _refreshData,
                      child: const Text('Retry'),
                    ),
                  ),
                ],
              );
            } else {
              final user = snapshot.data!;
              return ListView(
                children: [
                  ListTile(
                    title: Text(
                        'Name: ${user.first_name} ${user.middle_name} ${user.last_name}'),
                  ),
                  ListTile(
                    title: Text('Email: ${user.email}'),
                  ),
                  ListTile(
                    title: Text('Id: ${user.teacher_id}'),
                  ),
                  ListTile(
                    title: Text('Department: ${user.department}'),
                  ),
                  ListTile(
                    title: Text('Gender: ${user.gender}'),
                  ),
                  ListTile(
                    title: Text('Qualification: ${user.qualification}'),
                  ),
                  ListTile(
                    title: Text('Id key: ${user.id_key}'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
