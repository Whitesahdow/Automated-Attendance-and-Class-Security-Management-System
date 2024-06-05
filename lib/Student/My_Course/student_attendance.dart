import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AttendanceRecord {
  final DateTime date;
  final String status;
  final String clockIn;
  final String clockOut;

  AttendanceRecord({
    required this.date,
    required this.status,
    required this.clockIn,
    required this.clockOut,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: DateFormat('d/M/yyyy').parse(json['class_date']),
      status: json['arrived_at'],
      clockIn: json['arrived_at'] == "Didnt arrived yet" ? 'N/A' : json['at'],
      clockOut: json['arrived_at'] == "Didnt arrived yet" ? 'N/A' : json['at'],
    );
  }
}

class AttendanceList extends StatefulWidget {
  final String courseId;
  final String myToken;

  const AttendanceList({
    Key? key,
    required this.courseId,
    required this.myToken,
  }) : super(key: key);

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  late Future<List<AttendanceRecord>> attendanceData;

  @override
  void initState() {
    super.initState();
    attendanceData = fetchAttendanceRecords();
  }

  Future<List<AttendanceRecord>> fetchAttendanceRecords() async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://besufikadyilma.tech/student/my-attendance/${widget.courseId}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.myToken}"
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AttendanceRecord.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load attendance records');
      }
    } catch (error) {
      print('Error fetching attendance records: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance List',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'sedan'),
        ),
      ),
      body: FutureBuilder<List<AttendanceRecord>>(
        future: attendanceData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final attendanceRecords = snapshot.data!;
            return ListView.builder(
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {
                final attendanceRecord = attendanceRecords[index];
                return ListTile(
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color:
                                attendanceRecord.status == "Didnt arrived yet"
                                    ? const Color.fromARGB(139, 208, 43, 60)
                                    : const Color.fromARGB(98, 7, 223, 54),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attendanceRecord.status == "Didnt arrived yet"
                                    ? 'Missed/Skipped/Unavailable'
                                    : 'Attended',
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'sedan'),
                              ),
                              const SizedBox(height: 8.0),
                              if (attendanceRecord.status !=
                                  "Didnt arrived yet") ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time In: ${attendanceRecord.clockIn}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'sedan',
                                          color: Colors.black),
                                    ),
                                    const SizedBox(width: 10.0),
                                    Text(
                                      'Time Out: ${attendanceRecord.clockOut}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'sedan',
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                              Text(
                                DateFormat.yMMMEd()
                                    .format(attendanceRecord.date),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'sedan',
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
