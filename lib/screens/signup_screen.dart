import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  String errorMsg = '';
  Future<void> signup() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMsg = '';
    });

    try {
      // Validate inputs first
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Better email validation
      final bool emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

      if (email.isEmpty || password.isEmpty) {
        setState(() {
          errorMsg = 'Email and password cannot be empty';
          isLoading = false;
        });
        return;
      } else if (!emailValid) {
        setState(() {
          errorMsg = 'Please enter a valid email address';
          isLoading = false;
        });
        return;
      } else if (password.length < 6) {
        setState(() {
          errorMsg = 'Password must be at least 6 characters';
          isLoading = false;
        });
        return;
      }
      try {
        // Simple Firebase auth with proper error handling
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Verify that we got a user back
        if (userCredential.user != null && mounted) {
          Navigator.pushReplacementNamed(context, '/chat');
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMsg = e.message ?? 'Signup failed';
          isLoading = false;
        });
        return;
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message ?? 'Signup failed';
      });
    } catch (e) {
      setState(() {
        errorMsg = 'An unexpected error occurred: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  child: const Text("already have an account? Login"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (errorMsg.isNotEmpty)
              Text(
                errorMsg,
                style: const TextStyle(color: Colors.red),
              ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: signup,
                    child: const Text('Sign Up'),
                  ),
          ],
        ),
      ),
    );
  }
}
