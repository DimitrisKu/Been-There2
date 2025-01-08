
import 'register_screen.dart';
import '../components/custom_button.dart';
import 'package:flutter/material.dart';


// Η αρχικη οθονη μετα την splash screen. Πατας το "get started" κουμπι για να σε βγαλει στο register screen.
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top-left circles image
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Image.asset(
                'assets/images/circles.png', // Decorative circles
                width: 120,
                height: 120,
              ),
            ),
          ),
          const Spacer(),
          // Logo
          Image.asset(
            'assets/images/logo.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 24),
          const Text(
            'Been There, Done That',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Connect with your friends and share your experiences from places',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          // Button with reduced width
          SizedBox(
            width: 200, // Reduced width to match design
            child: CustomButton(
              text: 'Get Started',
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context) => RegistrationPage())
                ); // Navigate to Registration Page
              },
              backgroundColor: const Color(0xFF6C82BA), // Light blue
              textColor: Colors.white, // White text
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}