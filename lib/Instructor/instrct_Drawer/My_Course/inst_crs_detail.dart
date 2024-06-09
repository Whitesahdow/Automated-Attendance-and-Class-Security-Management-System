import 'dart:convert';
import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/student_attendance/student_attendance.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InstructorCourseDetail extends StatefulWidget {
  final String? myToken;
  final String id;

  const InstructorCourseDetail(this.myToken, this.id, {super.key});

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
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 40, 77),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Use desired arrow icon
          color: Colors.white, // Set color to white
          onPressed: () => Navigator.pop(context), // Handle back button press
        ),
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
                  SizedBox(
                    width: 500.0, // Adjust width as needed
                    height: 200.0,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Course Code: ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )), // Default style
                                  TextSpan(
                                    text: snapshot.data!.courseCode,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontStyle:
                                            FontStyle.italic), // Bold style
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Course Name: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .bold)), // Default style
                                  TextSpan(
                                    text: snapshot.data!.courseName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontStyle:
                                            FontStyle.italic), // Bold style
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Category: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .bold)), // Default style
                                  TextSpan(
                                    text: snapshot.data!.courseCategory,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontStyle:
                                            FontStyle.italic), // Bold style
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Department: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .bold)), // Default style
                                  TextSpan(
                                    text: snapshot.data!.courseDepartment,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontStyle:
                                            FontStyle.italic), // Bold style
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'Credit: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight
                                              .bold)), // Default style
                                  TextSpan(
                                    text: snapshot.data!.courseCredit,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontStyle:
                                            FontStyle.italic), // Bold style
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: ElevatedButton(
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
                        backgroundColor: const Color.fromARGB(131, 17, 38, 198),
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        fixedSize: const Size(195, 50),
                      ),
                      child: const Center(
                        child: Text(
                          'Student Attendance',
                          style: TextStyle(
                            color: Color.fromARGB(255, 239, 235, 235),
                            fontFamily: 'Lobster',
                            fontSize: 18,
                          ),
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
