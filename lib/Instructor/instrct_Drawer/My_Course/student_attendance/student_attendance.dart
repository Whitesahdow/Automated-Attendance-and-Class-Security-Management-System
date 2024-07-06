import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StuAttendance extends StatefulWidget {
  final String? myToken;
  final String? id;
  const StuAttendance(this.myToken, this.id, {super.key});

  @override
  State<StuAttendance> createState() => _StuAttendanceState();
}

class _StuAttendanceState extends State<StuAttendance> {
  List<stuList> studentList = [];
  bool isLoading = false;

  Future<void> getstuList() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(
      Uri.parse("https://besufikadyilma.tech/student/attendance/${widget.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.myToken}"
      },
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
<<<<<<< HEAD
      print("......................$jsonData");
      // studentList.clear();
=======
      studentList.clear();
>>>>>>> origin/main
      for (var eachStudentData in jsonData) {
        final stuList newStudent = stuList(
          student_id: eachStudentData['student_id'],
          total_no: eachStudentData['total_class'].toString(),
          attended_no: eachStudentData['attended'].toString(),
          batch: eachStudentData['batch'].toString(),
          section: eachStudentData['section'].toString(),
        );

        studentList.add(newStudent);
      }

      // Sort the student list by batch, section, and student_id
      studentList.sort((a, b) {
        int batchCompare = a.batch!.compareTo(b.batch!);
        if (batchCompare != 0) return batchCompare;
        int sectionCompare = a.section!.compareTo(b.section!);
        if (sectionCompare != 0) return sectionCompare;
        return a.student_id!.compareTo(b.student_id!);
      });

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

  @override
  void initState() {
    super.initState();
    getstuList();
  }

  Widget _buildTables() {
    Map<String, List<stuList>> groupedStudents = {};
    for (var student in studentList) {
      String key = 'Batch ${student.batch}, Section ${student.section}';
      if (!groupedStudents.containsKey(key)) {
        groupedStudents[key] = [];
      }
      groupedStudents[key]!.add(student);
    }

    return Column(
      children: groupedStudents.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
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
                          "Attended",
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
                          "Sessions",
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
                for (int i = 0; i < entry.value.length; i++)
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
                          child: Text(entry.value[i].student_id!),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(entry.value[i].attended_no!),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(entry.value[i].total_no!),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
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
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 40, 77),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
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
    );
  }
}

class stuList {
  String? student_id;
  String? total_no;
  String? attended_no;
  String? batch;
  String? section;

  stuList({
    required this.student_id,
    required this.total_no,
    required this.attended_no,
    required this.batch,
    required this.section,
  });
}
