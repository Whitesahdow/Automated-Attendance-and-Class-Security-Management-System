// ignore_for_file: use_rethrow_when_possible, use_super_parameters, avoid_print

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
        List<AttendanceRecord> records =
            data.map((json) => AttendanceRecord.fromJson(json)).toList();

        // Sort records by date in descending order
        records.sort((a, b) => b.date.compareTo(a.date));
        return records;
      } else {
        throw Exception('Failed to load attendance records');
      }
    } catch (error) {
      print('Error fetching attendance records: $error');
      throw error;
    }
  }

  Future<void> _refreshAttendanceList() async {
    setState(() {
      attendanceData = fetchAttendanceRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 17, 40, 77),
        title: const Text(
          'Attendance List',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'sedan',
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAttendanceList,
        child: FutureBuilder<List<AttendanceRecord>>(
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
                                const SizedBox(height: 5.0),
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
      ),
    );
  }
}
