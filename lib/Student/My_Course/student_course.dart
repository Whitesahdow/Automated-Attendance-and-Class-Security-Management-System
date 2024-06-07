// ignore_for_file: unused_import, must_be_immutable, camel_case_types, non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:AAMCS_App/Student/My_Course/course_detail.dart';
import 'package:AAMCS_App/Student/My_Course/course_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Student_Course extends StatelessWidget {
  List<Student_Courses> course_list = [];
  final String? My_Token;
  final String course_id;
  Student_Course(this.My_Token, this.course_id, {super.key});

  Future<List<Student_Courses>> getCourse() async {
    String url_base =
        "https://besufikadyilma.tech/instructor/get-class?student_id=";
    String url_id = course_id;
    print(".............................${course_id}");
    String url_final = url_base + url_id;
    print(".............................${url_final}");
    final response = await http.get(
      Uri.parse(url_final),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${My_Token}"
      },
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(".................................${jsonData[0]["courses"]} ....");
      print(jsonData.length);
      for (var i = 0; i < jsonData.length; i++) {
        if (jsonData[i]['courses'] != null &&
            jsonData[i]['courses'].length > 0) {
          for (var eachTeam in jsonData[i]["courses"]) {
            // print(eachTeam);
            final crsList = Student_Courses(
              course_category: eachTeam['category'].toString(),
              course_code: eachTeam['course_code'].toString(),
              course_credit: eachTeam['credit'].toString(),
              course_department: eachTeam['course_department'].toString(),
              course_name: eachTeam['name'].toString(),
              id: eachTeam['id'].toString(),
            );
            course_list.add(crsList);
          }
        } else {
          print("sdfghjklkjhgfdfghj2345678........................");
        }
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
        child: FutureBuilder<List<Student_Courses>>(
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
                              builder: (context) => StudentCourseDetail(
                                  My_Token,
                                  snapshot.data![index]
                                      .id) //for now it openes only mobile dev.t page
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
