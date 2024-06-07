import 'package:AAMCS_App/Login_out/controllers/auth_cntrl.dart';
import 'package:flutter/material.dart';
import 'package:AAMCS_App/Instructor/instructor_home.dart';
import 'package:AAMCS_App/Student/student_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userType = '';
  bool isLoading = false;
  void setUserType(String type) {
    setState(() {
      userType = type;
    });
  }

  AuthController auth_controller = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Avoid app bar for a clean login screen design
      appBar: null,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          // Allow scrolling if keyboard appears
          padding:
              const EdgeInsets.all(20.0), // Add some padding for aesthetics
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch horizontally
            children: <Widget>[
              Center(child: Image.asset('assets/images/AASTU_logo.png')),
              const SizedBox(
                  height: 40.0), // Add space between text and buttons

              // User type selection buttons
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center buttons horizontally
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        userType = 'teacher';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color:
                            userType == 'teacher' ? Colors.blue : Colors.grey,
                      ),
                    ),
                    child: const Text(
                      'Teacher',
                      style: TextStyle(fontFamily: 'Sedan', fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 20.0), // Add space between buttons
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        userType = 'student';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: userType == 'student'
                              ? Colors.blue
                              : Colors.grey),
                    ),
                    child: const Text(
                      'Student',
                      style: TextStyle(fontFamily: 'Sedan', fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  height: 20.0), // Add space between buttons and email field
              // Email text field
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: auth_controller
                    .username_controller, // Set keyboard type for email
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'sedan',
                    //   fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Rounded corners for aesthetics
                  ),
                ),
              ),
              const SizedBox(
                  height: 20.0), // Add space between email and password fields
              // Password text field
              TextField(
                obscureText: true, // Hide password characters
                controller: auth_controller.password_controller,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'sedan',
                    // fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Rounded corners for aesthetics
                  ),
                ),
              ),
              const SizedBox(
                  height: 20.0), // Add space between password field and button
              // Login button
              ElevatedButton(
                onPressed: () async {
                  // Show loading indicator
                  setState(() {
                    isLoading = true; // Flag to indicate loading state
                  });
                  var token = await auth_controller.loginuser(userType);
                  setState(() {
                    isLoading =
                        false; // Hide loading indicator after login attempt
                  });
                  if (auth_controller.reuest_responese.loginArr == "true") {
                    // Login successful, navigate
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => userType == 'teacher'
                            ? InstructorHome(token)
                            : StudentHome(token),
                      ),
                      ModalRoute.withName('/'),
                    );
                  } else {
                    // Login failed, show error dialog
                    _showLoginFailedDialog(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontFamily: 'sedan',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 1, 100, 181)) // Show progress indicator
                    : const Text(
                        'Login'), // Display "Login" text when not loading
              ),
              const SizedBox(
                  height:
                      12.0), // Add space between button and forgot password text
              // Forgot password text
            ],
          ),
        ),
      ),
    );
  }
}
void _showLoginFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        'Login Failed',
        style: TextStyle(
          fontFamily: 'Sedan',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.normal,
        ),
      ),
      content: const Text(
        'Please try again.',
        style: TextStyle(
          fontFamily: 'Sedan',
          fontSize: 17,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
              context), // Close dialog and return to the same page
          child: const Text('Okay'),
        ),
      ],
    ),
  );
}
