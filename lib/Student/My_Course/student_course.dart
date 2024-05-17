import 'dart:convert';
import 'package:AAMCS_App/Student/My_Course/course_detail.dart';
import 'package:AAMCS_App/Student/My_Course/stu_course.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyCourses extends StatelessWidget {
  List<Student_Courses> course_list = [];

  MyCourses(
      {super.key}); // a list of data type stu_course its the class i made in sru_course file

  Future<List<Student_Courses>> getCourse() async {
    var url = Uri.https('reqres.in', '/api/unknown');

    var response = await http.get(
      url,
      // headers: {
      //   'Authorization': 'Bearer $apiKey',
      // },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      for (var eachTeam in jsonData['data']) {
        final crsList = Student_Courses(
          name: eachTeam['name'],
          pantone_value: eachTeam['pantone_value'],
        );
        course_list.add(crsList);
        // an object was created called student_courses and in the object is a list
        // course_list is now a list which contains objects defined with different parameters
      }

      return course_list;
    } else {
      // Handle error here
      throw Exception('Failed to load ');
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
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].pantone_value),
                        onTap: () => Navigator.push(
                          // when the list is tapped it will open a page
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetails(
                                courseName:
                                    'Mobile App Development'), //for now it openes only mobile dev.t page
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
