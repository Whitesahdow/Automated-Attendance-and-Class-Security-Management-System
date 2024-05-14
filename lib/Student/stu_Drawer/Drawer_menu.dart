import 'dart:convert';
import 'package:AAMCS_App/Login_out/controllers/auth_cntrl.dart';
import 'package:AAMCS_App/Student/stu_Drawer/student_announcement.dart';
import 'package:AAMCS_App/Student/stu_Drawer/user_info.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:AAMCS_App/Login_out/logout.dart';
import 'package:AAMCS_App/Student/My_Course/student_course.dart';
//import 'package:AAMCS_App/Student/stu_Drawer/student_announcement.dart';
//import 'package:AAMCS_App/Student/student_home.dart';
import 'package:AAMCS_App/Student/stu_Drawer/student_profile.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late Future<user_info> _userDataFuture;

  AuthController auth_controller = AuthController();
  @override
  void initState() {
    super.initState();
    _userDataFuture = getdata();
  }

  Future<user_info> getdata() async {
    final response = await http
        .get(Uri.parse("https://besufikadyilma.tech/student/me"), headers: {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTcxNTY0NjgzMiwianRpIjoiODFjY2JlYzItYjQyZS00ZGI4LWFlNGMtYjNjOGEwYzVkYjM1IiwidHlwZSI6InN0dWRlbnQiLCJzdWIiOiJmY2UyY2MzNS00NmNkLTQ5NTUtYTZlZi03NjI2ZmRmZTY2OTMiLCJuYmYiOjE3MTU2NDY4MzIsImNzcmYiOiIyZGZmZTQ2Ni0yZGIzLTRjNGMtOTI3NC0wZDgxNTA5MjExZDciLCJleHAiOjE3MTU2NTA0MzJ9.9SSotDGHn6L9zdKBU4ev9k2QH4MNLJa7T5P8E5VRXX4",
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = user_info(
        first_name: data['first_name'],
        last_name: data['last_name'],
        email: data['email'],
        id: data['student_id'].toString(),
      );
      print(user.first_name);
      return user;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: _userDataFuture,
        builder: (context, AsyncSnapshot<user_info> snapshot) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(),
            children: [
              UserAccountsDrawerHeader(
                accountName: snapshot.hasData
                    ? Text(
                        '${snapshot.data!.first_name} ${snapshot.data!.last_name}',
                        style: const TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
                        'Error Loading Data',
                        style: TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                accountEmail: snapshot.hasData
                    ? Text(
                        snapshot.data!.email,
                        style: const TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : const Text(
                        'Error Loading Data',
                        style: TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/user.png',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/school1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/course.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'My Courses',
                      style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyCourses()),
                  );
                  print('My Courses button pressed!');
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/announcement.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'Announcements',
                      style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Announcement(
                        courseName: "course name goes here",
                        roomNumber: "roomNumber goes here",
                        isCancelled: true,
                        announcement: "announcement goes here",
                      ),
                    ),
                  );
                  print('Announcements button pressed!');
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/profile.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const StudentProfile(
                        first_name: '',
                        last_name: '',
                        email: '',
                        id: '',
                      ),
                    ),
                  );
                  print('Profile button pressed!');
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/icons/logout.png',
                      width: 25.0,
                      height: 25.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Sedan',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogoutPage()),
                  );
                  print('Logout button pressed!');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
