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
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 160.0), // Set only top padding
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    " Automated Attendance Management \n          and Class Security System",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Sedan',
                    ),
                  ),
                ),
                Center(
                  child: Image.asset("assets/images/AASTU_logo1.png"),
                ),
              ],
            ),
            const Center(
              child: Text(
                "    This App Is Designed For 5th Year Final Project.\n                                       trial phase",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Lobster',
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Lobster',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
