// ignore_for_file: unused_local_variable, library_private_types_in_public_api, non_constant_identifier_names

import 'dart:convert';
// import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/instr_course.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InstCrssDetails {
  final String? course_category;
  final String? course_code;
  final String? course_credit;
  final String? course_department;
  final String? course_name;
  final String? id;

  InstCrssDetails({
    required this.course_category,
    required this.course_code,
    required this.course_credit,
    required this.course_department,
    required this.course_name,
    required this.id,
  });
}

class courseinfo {
  final String id_key;

  courseinfo({
    required this.id_key,
  });
}

class InstructorCourseDetail extends StatefulWidget {
  final String? My_Token;
  final String id;
  const InstructorCourseDetail(this.My_Token, this.id, {super.key});

  @override
  State<InstructorCourseDetail> createState() => _InstructorCourseDetailState();
}

class _InstructorCourseDetailState extends State<InstructorCourseDetail> {
  late Future<InstCrssDetails> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = getdata();
  }

  Future<InstCrssDetails> getdata() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/course/getid/${widget.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.My_Token}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final courseDetails = InstCrssDetails(
        course_category: data['course_category'],
        course_code: data['course_code'],
        course_credit: data['course_credit'],
        course_department: data['course_department'],
        course_name: data['course_name'],
        id: data['id'],
      );
      return courseDetails;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Detail',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 170, 163, 163),
      ),
      body: FutureBuilder<InstCrssDetails>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: Cant find anything'));
          } else {
            final courseDetails = snapshot.data!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('course_code: ${snapshot.data!.course_code}'),
                  Text('course_name: ${snapshot.data!.course_name}'),
                  Text('course_category: ${snapshot.data!.course_category}} '),
                  Text(
                      'course_department: ${snapshot.data!.course_department}'),
                  Text('course_credit: ${snapshot.data!.course_credit} '),
                  Text('Id key: ${snapshot.data!.id} '),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
