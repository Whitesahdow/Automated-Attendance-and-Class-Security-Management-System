import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentProfile extends StatefulWidget {
  final String? My_Token;
  const StudentProfile(this.My_Token, {super.key});

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  late Future<StudentInfo> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = getdata();
  }

  Future<StudentInfo> getdata() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/student/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.My_Token}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = StudentInfo(
        first_name: data['first_name'],
        middle_name: data['middle_name'],
        last_name: data['last_name'],
        email: data['email'],
        department: data['department'],
        gender: data['gender'],
        batch: data['batch'],
        section: data['section'],
        id: data['student_id'].toString(),
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
      await newData;
    } catch (e) {
      print('Error refreshing data: $e');
    }
  }

  Widget buildProfileCard(String title, String content, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Profile',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 40, 77),
        elevation: 0,
        shadowColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Use desired arrow icon
          color: Colors.white, // Set color to white
          onPressed: () => Navigator.pop(context), // Handle back button press
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<StudentInfo>(
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
                padding: const EdgeInsets.all(8.0),
                children: [
                  const SizedBox(height: 20),
                  buildProfileCard(
                      'Name',
                      '${user.first_name} ${user.middle_name} ${user.last_name}',
                      Icons.person),
                  buildProfileCard('Email', user.email, Icons.email),
                  buildProfileCard('Student Id', user.id, Icons.badge),
                  buildProfileCard(
                      'Department', user.department, Icons.business),
                  buildProfileCard('Gender', user.gender, Icons.person_outline),
                  buildProfileCard('Batch', user.batch, Icons.school),
                  buildProfileCard('Section', user.section, Icons.class_),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class StudentInfo {
  final String first_name;
  final String middle_name;
  final String last_name;
  final String email;
  final String department;
  final String gender;
  final String batch;
  final String section;
  final String id;
  final String id_key;

  StudentInfo({
    required this.first_name,
    required this.middle_name,
    required this.last_name,
    required this.email,
    required this.department,
    required this.gender,
    required this.batch,
    required this.section,
    required this.id,
    required this.id_key,
  });
}
