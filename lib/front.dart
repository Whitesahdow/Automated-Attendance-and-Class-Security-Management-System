import 'package:flutter/material.dart';
import 'package:AAMCS_App/Login_out/login.dart';

class Frontpage extends StatelessWidget {
  const Frontpage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Automated Attendance Management \nand Class Security System",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sedan',
                ),
              ),
              SizedBox(height: 20), // Add some space
              Image.asset(
                "assets/images/AASTU_logo1.png",
                height: 150, // Adjust image height as needed
              ),
              SizedBox(height: 20), // Add some space
              Text(
                "This App Is Designed For 5th Year Final Project.\ntrial phase",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Lobster',
                ),
              ),
              SizedBox(height: 20), // Add some space
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lobster',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
