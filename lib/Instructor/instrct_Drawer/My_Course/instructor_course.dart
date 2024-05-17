import 'dart:convert';
import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/instr_course.dart';
import 'package:AAMCS_App/Student/My_Course/course_detail.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Instructor_course extends StatelessWidget {
  final String? My_Token;
  List<Instructor_Courses> course_list = [];
  Instructor_course(this.My_Token, {super.key});

  Future<List<Instructor_Courses>> getCourse() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/instructor/my-courses"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${My_Token}"
      },
    );
    print("......................\n$My_Token");
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      for (var eachTeam in jsonData) {
        final crsList = Instructor_Courses(
          course_category: eachTeam['course_category'],
          course_code: eachTeam['course_code'],
          course_credit: eachTeam['course_credit'],
          course_department: eachTeam['course_department'],
          course_name: eachTeam['course_name'],
          id: eachTeam['id'],
        );
        course_list.add(crsList);
      }

      return course_list;
    } else {
      // Handle error here
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course List',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 170, 163, 163),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Instructor_Courses>>(
          future: getCourse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // circular loading while it fetchs the data
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                      'Error:${snapshot.stackTrace} ${snapshot.error}')); // if failed
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        // it returns a list with padding of the fetched data
                        title: Text(snapshot.data![index].course_name),
                        subtitle: Text(
                            "Credit Hours: ${snapshot.data![index].course_credit}"),
                        onTap: () => Navigator.push(
                          // when the list is tapped it will open a page
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetails(
                                courseName: snapshot.data![index]
                                    .course_name), //for now it openes only mobile dev.t page
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
