import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String middleName; // Optional middle name
  final String gender;
  final String studentId;
  final String email;
  final String department;
  final String batchSection;

  const StudentProfile({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.gender,
    required this.studentId,
    required this.email,
    required this.department,
    required this.batchSection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile',
              style: TextStyle(
                  fontFamily: 'Sedan',
                  fontSize: 22,
                  fontWeight: FontWeight.bold)), // Centered title
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 20.0),

            Text("Name: $firstName $middleName $lastName",
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Gender: $gender',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Student ID: $studentId',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Email: $email',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Department: $department',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Batch Section: $batchSection'),
          ],
        )));
  }
}
