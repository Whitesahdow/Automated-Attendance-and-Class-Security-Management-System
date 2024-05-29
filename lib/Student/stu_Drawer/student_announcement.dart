import 'package:flutter/material.dart';

class Announcement extends StatelessWidget {
  final String courseName;
  final String roomNumber;
  final String? start_time;

  // Optional announcement

  const Announcement({
    super.key,
    required this.courseName,
    required this.roomNumber,
    this.start_time,
  });
// like the video i saw django and flutter this page should be api request refresh yemidereg update yemigegnibet
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Announcement',
              style: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Course:',
                      style: TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(courseName,
                      style: const TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Room number:',
                      style: TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(roomNumber,
                      style: const TextStyle(
                          fontFamily: 'Sedan',
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                ],
              ),
            ])));
  }
}
