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
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 40, 77),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Use desired arrow icon
          color: Colors.white, // Set color to white
          onPressed: () => Navigator.pop(context), // Handle back button press
        ),
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
                  SizedBox(
                    width: 500.0, // Adjust width as needed
                    height: 200.0, // Adjust height as needed
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                    ),
                                  ), // Default style
                                  TextSpan(
                                    text: courseDetails.course_code,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ), // Bold style
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), // Default style
                                  TextSpan(
                                    text: courseDetails.course_name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ), // Bold style
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), // Default style
                                  TextSpan(
                                    text: courseDetails.course_category,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ), // Bold style
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), // Default style
                                  TextSpan(
                                    text: courseDetails.course_department,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ), // Bold style
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ), // Default style
                                  TextSpan(
                                    text: courseDetails.course_credit,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ), // Bold style
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
                            builder: (context) => AttendanceList(
                              courseId: widget.course_id,
                              myToken: widget.My_Token!,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(131, 17, 38, 198),
                        padding: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        fixedSize: const Size(190, 50),
                      ),
                      child: const Text(
                        'My Attendance',
                        style: TextStyle(
                            fontFamily: 'Lobster',
                            color: Color.fromARGB(255, 239, 235, 235),
                            fontStyle: FontStyle.italic,
                            fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
