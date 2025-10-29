import 'dart:ui';
import 'package:flutter/gestures.dart';


import 'package:flutter/material.dart';
import 'package:flutter_application_3/View/player_dashboard.dart';
import 'package:flutter_application_3/View/signup/player_register_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// --- Modern Gradient Glow Theme ---
const Color kDarkBlue = Color(0xFF0F2027);
const Color kCardGlass = Color(0x1AFFFFFF);
const Color kAccentCyan = Color(0xFF00A8E8);
const Color kTextPrimary = Colors.white;
const Color kTextSecondary = Colors.white70;
const Color kBorderLight = Colors.white24;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false; // --- ADDED for loading state ---

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // --- MODIFIED: Dummy Login Logic ---
  Future<void> _login() async {
    // 1. Validate the form
    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if form is invalid
    }

    // 2. Start loading
    setState(() {
      _isLoading = true;
    });

    // 3. Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final email = _emailCtrl.text;
    final pass = _passCtrl.text;

    // 4. Dummy check
    if (email == 'test@test.com' && pass == 'password123') {
      // 5. Success: Navigate to a dummy home page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PlayerDashboardPage()),
        );
      }
    } else {
      // 6. Error: Show SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Invalid email or password. Try "test@test.com" and "password123".'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    // 7. Stop loading
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- ADDED: Register function to handle loading state ---
  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a brief delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const JoinSportsProPage(),
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- HEADER ---
                  const SizedBox(height: 30),
                  const Text(
                    "Welcome to SportLens",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Sign up or log in to continue your journey to athletic excellence.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: kTextSecondary,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- GLASS FORM CARD ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: kCardGlass,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kBorderLight, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: kAccentCyan.withOpacity(0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField(
                                controller: _emailCtrl,
                                hint: "Email Address",
                                prefixIcon: Icons.email_outlined,
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                controller: _passCtrl,
                                hint: "Password",
                                isPassword: true,
                                prefixIcon: Icons.lock_outline,
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _isLoading ? null : () {},
                                  child: const Text(
                                    "Forgot password?",
                                    style: TextStyle(
                                      color: kTextSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // --- BUTTONS (MODIFIED for loading) ---
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _isLoading ? null : _login,
                                      style: OutlinedButton.styleFrom(
                                        side:
                                            const BorderSide(color: kAccentCyan),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 19,
                                              width: 19,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: kAccentCyan),
                                            )
                                          : const Text(
                                              "Login",
                                              style: TextStyle(
                                                color: kAccentCyan,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _register,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kAccentCyan,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        shadowColor:
                                            kAccentCyan.withOpacity(0.5),
                                        elevation: 8,
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 19,
                                              width: 19,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: kTextPrimary),
                                            )
                                          : const Text(
                                              "Register",
                                              style: TextStyle(
                                                color: kTextPrimary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- DIVIDER ---
                  const Row(
                    children: [
                      Expanded(child: Divider(color: kBorderLight)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("or",
                            style: TextStyle(color: kTextSecondary)),
                      ),
                      Expanded(child: Divider(color: kBorderLight)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  const Center(
                    child: Text(
                      "Join With Your Favourite Social Media Account",
                      style: TextStyle(
                          color: kTextSecondary, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- SOCIAL BUTTONS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                          icon: FontAwesomeIcons.google,
                          onPressed: _isLoading ? () {} : () {}),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                          icon: FontAwesomeIcons.facebook,
                          onPressed: _isLoading ? () {} : () {}),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                          icon: FontAwesomeIcons.xTwitter,
                          onPressed: _isLoading ? () {} : () {}),
                      const SizedBox(width: 16),
                      _buildSocialButton(
                          icon: FontAwesomeIcons.apple,
                          onPressed: _isLoading ? () {} : () {}),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- FOOTER ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                            color: kTextSecondary, height: 1.5, fontSize: 13),
                        children: [
                          const TextSpan(
                              text: "By signing in, you agree to SportLens's "),
                          TextSpan(
                            text: "Terms of Service",
                            style: const TextStyle(
                                color: kTextPrimary,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: const TextStyle(
                                color: kTextPrimary,
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Text Field Widget ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: const TextStyle(color: kTextPrimary, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kTextSecondary),
        filled: true,
        fillColor: Colors.white10,
        prefixIcon: Icon(prefixIcon, color: kTextSecondary),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: kTextSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kBorderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kAccentCyan, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          // --- ADDED: Error Style ---
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // --- ADDED: Focused Error Style ---
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hint';
        }
        if (hint == "Email Address" && !value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  // --- Social Button Widget ---
  Widget _buildSocialButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        side: const BorderSide(color: kBorderLight),
        backgroundColor: Colors.white10,
      ),
      child: FaIcon(icon, size: 22, color: kTextPrimary),
    );
  }
}

//
// --- DUMMY HOME PAGE ---
// (Add this class to the end of your file for the login to work)
//
class DummyHomePage extends StatelessWidget {
  const DummyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: kDarkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            // Navigate back to Login/Sign Up page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const SignUpPage()),
            );
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Login Successful!',
          style: TextStyle(
            color: kTextPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}