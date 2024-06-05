import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_attendance.dart';

class StuCrssDetails {
  final String course_category;
  final String course_code;
  final String course_credit;
  final String course_department;
  final String course_name;
  final String id;

  StuCrssDetails({
    required this.course_category,
    required this.course_code,
    required this.course_credit,
    required this.course_department,
    required this.course_name,
    required this.id,
  });
}

class StudentCourseDetail extends StatefulWidget {
  final String? My_Token;
  final String course_id;

  StudentCourseDetail(this.My_Token, this.course_id, {super.key});

  @override
  State<StudentCourseDetail> createState() => _StudentCourseDetailState();
}

class _StudentCourseDetailState extends State<StudentCourseDetail> {
  late Future<StuCrssDetails> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = getdata();
  }

  Future<StuCrssDetails> getdata() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/course/getid/${widget.course_id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.My_Token}"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final courseDetails = StuCrssDetails(
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
      body: FutureBuilder<StuCrssDetails>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: Cannot find anything'));
          } else {
            final courseDetails = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Code: ${courseDetails.course_code}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Divider(),
                  Text(
                    'Course Name: ${courseDetails.course_name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Divider(),
                  Text(
                    'Course Category: ${courseDetails.course_category}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Divider(),
                  Text(
                    'Course Department: ${courseDetails.course_department}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Divider(),
                  Text(
                    'Course Credit: ${courseDetails.course_credit}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sedan',
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 24.0),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 170, 163, 163), // Button color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Sedan',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceList(
                              courseId: widget.course_id,
                              myToken: widget.My_Token!,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'My Attendance',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Sedan',
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
