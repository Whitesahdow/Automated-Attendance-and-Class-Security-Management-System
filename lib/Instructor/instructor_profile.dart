import 'package:flutter/material.dart';

class InstructorProfile extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String middleName; // Optional middle name
  final String gender;
  final String instructorId;
  final String email;
  final String phoneNumber;
  final String department;
  final String qualification;

  const InstructorProfile({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.gender,
    required this.instructorId,
    required this.email,
    required this.phoneNumber,
    required this.department,
    required this.qualification,
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
            Text('Student ID: $instructorId',
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
            Text('Phone Number: $phoneNumber',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            const SizedBox(height: 4.0),
            Text('Department: $department',
                style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            const SizedBox(height: 4.0),
            Text('Batch Section: $qualification',
            style: const TextStyle(
                    fontFamily: 'Sedan',
                    fontSize: 16,
                    fontWeight: FontWeight.normal)),
            
          ],
        )));
  }
}
