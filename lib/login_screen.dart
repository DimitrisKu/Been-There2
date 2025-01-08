import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import 'Feed.dart';



// Η log in screen. Εχει υλοποιηθει η διαδικασια log in και για να πετυχει πρεπει να βαλεις σωστο ονομα και κωδικο. Σε περιπτωση λαθους
// βγαζει καταλληλο μηνυμα (λαθος username ή λαθος κωδικος). Δεν εχουμε υλοποιησει το forgot password και το sign up.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonPressed = false;

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {

      final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('UserName', isEqualTo: email)
      .get();

      if (userSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
        return;
      }

      final userDoc = userSnapshot.docs.first;
      final storedPassword = userDoc['Password'];

      if (storedPassword == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Feed_Widget(),
            settings: RouteSettings(arguments: email),
            ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid password')),
        );
      }
    }

    catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light gray background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              // Decorative Circles
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/circles.png',
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Log in to your account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                hintText: 'Enter your username',
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Enter your password',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
//                  Navigator.pushNamed(context, AppRoutes.forgotPassword);
                },
                child: const Text(
                  'Forgot password',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFF6C82BA), // Blue color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTapDown: (_) => setState(() => _isButtonPressed = true),
                onTapUp: (_) => setState(() => _isButtonPressed = false),
                onTapCancel: () => setState(() => _isButtonPressed = false),
                onTap: _login,
                child: CustomButton(
                  text: 'Log In',
                  isPressed: _isButtonPressed,
                   onPressed: _login,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don’t have an account? ',
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
//                      Navigator.pushReplacementNamed(context, AppRoutes.register);
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Color(0xFF6C82BA), // Blue color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}