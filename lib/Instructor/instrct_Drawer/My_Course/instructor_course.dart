// ignore_for_file: unused_import, must_be_immutable, camel_case_types, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/crs_dtls_list.dart';
import 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/inst_crs_detail.dart';
// flutter build appbundle --releaseimport 'package:AAMCS_App/Instructor/instrct_Drawer/My_Course/crs_details_lists.dart';
import 'package:AAMCS_App/Student/My_Course/course_detail.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Instructor_course extends StatelessWidget {
  List<Instructor_Courses> course_list = [];
  final String? My_Token;

  Instructor_course(this.My_Token, {super.key});

  Future<List<Instructor_Courses>> getCourse() async {
    final response = await http.get(
      Uri.parse("https://besufikadyilma.tech/instructor/my-courses"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${My_Token}"
      },
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(jsonData);
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
      throw Exception('Failed to load teams');
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
                            builder: (context) => InstructorCourseDetail(
                                My_Token,
                                snapshot.data![index]
                                    .id), //for now it openes only mobile dev.t page
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
