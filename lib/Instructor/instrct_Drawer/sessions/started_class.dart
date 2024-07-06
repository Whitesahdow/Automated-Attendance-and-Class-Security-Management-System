import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Started_Class extends StatefulWidget {
  final String? myToken;
  final String? Course_id;
  const Started_Class(this.myToken, this.Course_id, {Key? key})
      : super(key: key);

  @override
  State<Started_Class> createState() => _Started_ClassState();
}

class _Started_ClassState extends State<Started_Class> {
  List<In_class_STU> studentList = [];
  bool isLoading = false;

  Future<void> getstuList() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(
      Uri.parse("https://besufikadyilma.tech/instructor/in-class"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.myToken}"
      },
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      studentList.clear();
      for (var eachStudentData in jsonData) {
        final In_class_STU newStudent = In_class_STU(
          student_id: eachStudentData['student_id'].toString(),
          first_name: eachStudentData['first_name'].toString(),
          arrived_time: eachStudentData['arrived_time'].toString(),
          batch: eachStudentData['batch'].toString(),
          section: eachStudentData['section'].toString(),
        );
        studentList.add(newStudent);
      }

      // Sort the student list by student_id only
      studentList.sort((a, b) => a.student_id!.compareTo(b.student_id!));

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load student data');
    }
  }

<<<<<<< HEAD
  Future<String?> Activate_Delete_session(String? Mytoken) async {
    const urlBase = "https://besufikadyilma.tech/activate/end/session/";
=======
  Future<String?> Activate_Delete_session(String? myToken) async {
    const url_base = "https://besufikadyilma.tech/activate/end/session/";
>>>>>>> origin/main
    try {
      var response = await http.get(
        Uri.parse(urlBase),
        headers: {
          "Content-Type": "application/json",
<<<<<<< HEAD
          "Authorization": "Bearer $Mytoken"
=======
          "Authorization": "Bearer $myToken"
>>>>>>> origin/main
        },
      );

      if (response.statusCode == 200) {
        var activateDeleteSession = jsonDecode(response.body);
<<<<<<< HEAD

        var activateDeleteResonse = activateDeleteSession['msg'].toString();
        print(
            "................ delete is runing........................................$activateDeleteResonse");

        return activateDeleteResonse;
=======
        var activateDeleteResponse = activateDeleteSession['msg'].toString();
        return activateDeleteResponse;
>>>>>>> origin/main
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    getstuList();
  }

  Widget _buildTables() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2.5),
            2: FlexColumnWidth(2.5),
            3: FlexColumnWidth(2.5),
          },
          border: TableBorder.all(
            color: Colors.grey,
            width: 1.0,
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              children: const [
                TableCell(
                  child: Center(
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      "ID",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      "First Name",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Text(
                      "Arrived",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            for (int i = 0; i < studentList.length; i++)
              TableRow(
                decoration: BoxDecoration(
                  color: i % 2 == 0 ? Colors.grey[200] : null,
                ),
                children: [
                  TableCell(
                    child: Center(
                      child: Text((i + 1).toString()),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(studentList[i].student_id!),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(studentList[i].first_name!),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Text(studentList[i].arrived_time!),
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Attendance List',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 170, 163, 163),
      ),
      body: RefreshIndicator(
        onRefresh: getstuList,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : ListView(
                  children: [_buildTables()],
                ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            final confirmed = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Attention!'),
                content:
                    const Text('Are you sure you want to end the session?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
            if (confirmed ?? false) {
              await Activate_Delete_session(widget.myToken);
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'End Session',
              style: TextStyle(
                  fontSize: 18.0, color: Color.fromARGB(255, 2, 34, 61)),
            ),
          ),
        ),
      ),
    );
  }
}

class In_class_STU {
  late String? first_name;
  late String? student_id;
  late String? arrived_time;
  late String? batch;
  late String? section;

  In_class_STU({
    required this.first_name,
    required this.student_id,
    required this.arrived_time,
    required this.batch,
    required this.section,
  });
}
