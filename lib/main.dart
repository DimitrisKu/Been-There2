
import 'package:been_there/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'get_started_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      home: SplashScreen()
    )
    );
}

// Η αρχικη splash screen οθονη
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetStartedScreen())
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF43617C), // Adjusted background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              "Been There, Done That",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white, // Changed text color to white
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
class Welcome_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Προσθέτει στοίχιση στο κέντρο
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20), // Χώρος μεταξύ εικόνας και κειμένου
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn_Widget()),
                );
              },
              child: const Text('Been There'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

/*
class Welcome_Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center( 
        child: Column( 
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Logo.png'),
                  fit: BoxFit.cover
                )
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn_Widget())
                  );
                },
                child: Text('Been There')
              ),
            )
        ]
      )
      )
    );
      
  }

}
*/
