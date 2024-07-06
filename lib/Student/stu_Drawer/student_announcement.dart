import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Announcement extends StatefulWidget {
  final String? my_token;

  const Announcement({
    super.key,
    required this.my_token,
  });

  @override
  State<Announcement> createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  late Future<AnnouncementData> announcementData;

  @override
  void initState() {
    super.initState();
    announcementData = getAnnouncements();
  }

  Future<AnnouncementData> getAnnouncements() async {
    try {
      final response = await http.get(
        Uri.parse("https://besufikadyilma.tech/student/my-announcment"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.my_token}"
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Parse the JSON response if the request was successful
        final data = jsonDecode(response.body);
        return AnnouncementData.fromJson(data);
      } else {
        // Handle the case where the server returned an error
        throw Exception('Failed to load announcements');
      }
    } catch (error) {
      // Handle any exceptions that occurred during the request
      print('Error fetching announcements: $error');
      rethrow;
    }
  }

  Future<void> _refreshAnnouncements() async {
    setState(() {
      announcementData = getAnnouncements();
    });
    await announcementData; // Wait for the data to be refreshed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Announcement',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 40, 77),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAnnouncements,
        child: FutureBuilder<AnnouncementData>(
          future: announcementData,
          builder: (context, snapshot) {
            return _buildAnnouncementWidget(snapshot);
          },
        ),
      ),
    );
  }

  Widget _buildAnnouncementWidget(AsyncSnapshot<AnnouncementData> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.hasData) {
      final data = snapshot.data!;
      if (data.msg) {
        return Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Course: ',
                              style: TextStyle(
                                fontFamily: 'Sedan',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                data.course ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Sedan',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text(
                              'Instructor: ',
                              style: TextStyle(
                                fontFamily: 'Sedan',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Mr.${data.instructor ?? ''}",
                              style: const TextStyle(
                                fontFamily: 'Sedan',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text(
                              'Room number: ',
                              style: TextStyle(
                                fontFamily: 'Sedan',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data.roomNumber ?? '',
                              style: const TextStyle(
                                fontFamily: 'Sedan',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            const Text(
                              'Start time: ',
                              style: TextStyle(
                                fontFamily: 'Sedan',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data.startTime ?? '',
                              style: const TextStyle(
                                fontFamily: 'Sedan',
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        return const Center(
          child: Text(
            'No announcement today, enjoy!!',
            style: TextStyle(
              fontFamily: 'Sedan',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    } else {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(
            fontFamily: 'Sedan',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}

class AnnouncementData {
  final String? course;
  final String? instructor;
  final String? roomNumber;
  final String? startTime;
  final bool msg;

  AnnouncementData({
    this.course,
    this.instructor,
    this.roomNumber,
    this.startTime,
    required this.msg,
  });

  factory AnnouncementData.fromJson(Map<String, dynamic> json) {
    return AnnouncementData(
      course: json['course'],
      instructor: json['instructor'],
      roomNumber: json['room'],
      startTime: json['start_time'],
      msg: json['msg'],
    );
  }
}
