import 'dart:convert';
import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/student_attendance/student_attendance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InstructorCourseDetail extends StatefulWidget {
  final String? myToken;
  final String id;

  const InstructorCourseDetail(this.myToken, this.id, {Key? key})
      : super(key: key);

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
        "Authorization": "Bearer ${widget.myToken}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final courseDetails = InstCrssDetails(
        courseCode: data['course_code'],
        courseName: data['course_name'],
        courseCategory: data['course_category'],
        courseDepartment: data['course_department'],
        courseCredit: data['course_credit'],
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
        elevation: 0,
      ),
      body: FutureBuilder<InstCrssDetails>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.amber), // Customize the color
                strokeWidth: 6, // Increase the stroke width
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: Cannot find anything'));
          } else {
            final courseDetails = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Course Code: ${snapshot.data!.courseCode}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Course Name: ${snapshot.data!.courseName}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Category: ${snapshot.data!.courseCategory}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Department: ${snapshot.data!.courseDepartment}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Credit: ${snapshot.data!.courseCredit}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StuAttendance(widget.myToken, widget.id),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(131, 17, 38, 198),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Center(
                      child: const Text(
                        'Student Attendance',
                        style: TextStyle(
                          color: Color.fromARGB(255, 239, 235, 235),
                          fontFamily: 'Lobster',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class InstCrssDetails {
  final String courseCode;
  final String courseName;
  final String courseCategory;
  final String courseDepartment;
  final String courseCredit;
  final String id;

  InstCrssDetails({
    required this.courseCode,
    required this.courseName,
    required this.courseCategory,
    required this.courseDepartment,
    required this.courseCredit,
    required this.id,
  });
}
