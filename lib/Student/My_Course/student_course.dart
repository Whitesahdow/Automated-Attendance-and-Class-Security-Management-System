import 'package:flutter/material.dart';
import 'package:AAMCS_App/Student/My_Course/course_detail.dart';

class MyCourses extends StatelessWidget {
  MyCourses({super.key});
  final List<String> courseNames = [
    'Mobile App Development',
    'Database Management Systems',
    'Software Engineering',
    'Artificial Intelligence',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'My Courses',
        style: TextStyle(
            fontFamily: 'Sedan', fontSize: 22, fontWeight: FontWeight.bold),
      )),
      body: ListView.builder(
        itemCount: courseNames.length,
        itemBuilder: (context, index) {
          final courseName = courseNames[index];
          return ListTile(
            title: Text(
              courseName,
              style: const TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetails(courseName: courseName),
              ),
            ),
          );
        },
      ),
    );
  }
}
