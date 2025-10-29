import 'dart:ui'; // Needed for BackdropFilter
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/View/Club/welcomepage.dart';



// --- Theme Colors from CoachRegistrationPage ---
const Color kDarkBlue = Color(0xFF0F2027); // Used for field fills & dropdown
const Color kCardGlass = Color(0x1AFFFFFF); // Glass effect color
const Color kAccentCyan = Color(0xFF00A8E8); // Main accent color
const Color kTextPrimary = Colors.white;
const Color kTextSecondary = Colors.white70;
// Gradient colors for the background
const Color kGradientStart = Color(0xFF0F2027);
const Color kGradientMid = Color(0xFF203A43);
const Color kGradientEnd = Color(0xFF2C5364);
// --- End of Theme Colors ---

class ClubRegistrationPage extends StatefulWidget {
  const ClubRegistrationPage({super.key});

  @override
  State<ClubRegistrationPage> createState() => _ClubRegistrationPageState();
}

class _ClubRegistrationPageState extends State<ClubRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for Club Information
  final _clubNameController = TextEditingController();
  final _foundedYearController = TextEditingController();
  final _membershipController = TextEditingController();
  final _sportsOfferedController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Controllers for Contact Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State variables
  String? _selectedClubType;
  bool _useEmail = true;
  bool _otpSent = false;
  bool _otpVerified = false;
  bool _agree = false;

  @override
  void dispose() {
    // Dispose all controllers
    _clubNameController.dispose();
    _foundedYearController.dispose();
    _membershipController.dispose();
    _sportsOfferedController.dispose();
    _descriptionController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if ((_useEmail && _emailController.text.isNotEmpty) || (!_useEmail && _phoneController.text.isNotEmpty)) {
      setState(() => _otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully (demo).')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email or phone number first.')),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text.isNotEmpty) {
      setState(() => _otpVerified = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified!')),
      );
    }
  }

  void _createAccount() {
    if (_formKey.currentState!.validate()) {
      if (!_otpVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please verify your email or phone.')),
        );
        return;
      }
      if (!_agree) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must agree to the Terms & Conditions.')),
        );
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const WelcomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kGradientStart, kGradientMid, kGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: Colors.transparent,
              floating: true,
              snap: true,
              leading: BackButton(color: kTextSecondary),
              centerTitle: true,
              title: Text(
                'Club Registration',
                style: TextStyle(color: kTextPrimary, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // --- Header Icon ---
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: kAccentCyan,
                        child: Icon(Icons.business, color: kTextPrimary, size: 40),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Register your sports facility',
                        style: TextStyle(color: kTextSecondary, fontSize: 16),
                      ),
                      const SizedBox(height: 32),

                      // --- Club Information Section ---
                      _buildSectionCard(
                        title: 'Club Information',
                        child: Column(
                          children: [
                            _buildTextField(controller: _clubNameController, label: 'Club Name'),
                            const SizedBox(height: 16),
                            _buildDropdownField(
                              value: _selectedClubType,
                              label: 'Club Type',
                              hint: 'Select club type',
                              items: ['Sports Club', 'Fitness Center', 'Youth Academy', 'Professional Training Facility', 'Community Center', 'School/University', 'Recreation Center'],
                              onChanged: (value) => setState(() => _selectedClubType = value),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildTextField(controller: _foundedYearController, label: 'Founded Year', keyboardType: TextInputType.number)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildTextField(controller: _membershipController, label: 'Membership Capacity', keyboardType: TextInputType.number)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(controller: _sportsOfferedController, label: 'Sports Offered', hint: 'e.g., Football, Basketball, Tennis'),
                            const SizedBox(height: 16),
                            _buildTextField(controller: _descriptionController, label: 'Club Description', hint: 'Tell us about your club\'s mission...', maxLines: 3),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Contact Information Section ---
                      _buildSectionCard(
                        title: 'Contact Information',
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildTextField(controller: _firstNameController, label: 'Contact First Name')),
                                const SizedBox(width: 16),
                                Expanded(child: _buildTextField(controller: _lastNameController, label: 'Contact Last Name')),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildOtpVerification(),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildTextField(controller: _websiteController, label: 'Website', hint: 'https://', keyboardType: TextInputType.url)),
                                const SizedBox(width: 16),
                                Expanded(child: _buildTextField(controller: _addressController, label: 'Address')),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildTextField(controller: _cityController, label: 'City')),
                                const SizedBox(width: 16),
                                Expanded(child: _buildTextField(controller: _stateController, label: 'State')),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildTextField(controller: _passwordController, label: 'Password', obscureText: true)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _confirmPasswordController,
                                    label: 'Confirm Password',
                                    obscureText: true,
                                    validator: (value) {
                                      if (value != _passwordController.text) return 'Passwords do not match.';
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      _buildTermsAndConditions(),
                      const SizedBox(height: 24),

                      // --- UPDATED Register Button ---
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _createAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentCyan, // Solid cyan color
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const StadiumBorder(), // Pill shape like the screenshot
                            elevation: 5, // Optional: slight shadow to lift it
                          ),
                          child: const Text(
                            'Register', // Updated Text
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kTextPrimary, // White text
                            ),
                          ),
                        ),
                      ),
                      // --- END OF UPDATE ---

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets (Unchanged from previous versions) ---
  Widget _buildOtpVerification() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Verify by:', style: TextStyle(color: kTextSecondary)),
            Radio<bool>(
                value: true,
                groupValue: _useEmail,
                onChanged: (v) => setState(() => _useEmail = v!),
                activeColor: kAccentCyan),
            Text('Email', style: TextStyle(color: _useEmail ? kTextPrimary : kTextSecondary)),
            Radio<bool>(
                value: false,
                groupValue: _useEmail,
                onChanged: (v) => setState(() => _useEmail = v!),
                activeColor: kAccentCyan),
            Text('Phone', style: TextStyle(color: !_useEmail ? kTextPrimary : kTextSecondary)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _useEmail
                  ? _buildTextField(controller: _emailController, label: 'Email')
                  : _buildTextField(controller: _phoneController, label: 'Phone', keyboardType: TextInputType.phone),
            ),
            const SizedBox(width: 12),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: _otpSent ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentCyan,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(_otpSent ? 'Resend' : 'OTP', style: const TextStyle(color: kTextPrimary)),
              ),
            ),
          ],
        ),
        if (_otpSent) ...[
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTextField(controller: _otpController, label: 'Enter OTP', keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: _otpVerified ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _otpVerified ? Colors.green : kAccentCyan,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(_otpVerified ? 'Verified' : 'Verify', style: const TextStyle(color: kTextPrimary)),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _agree,
          onChanged: (value) => setState(() => _agree = value!),
          checkColor: kDarkBlue,
          activeColor: kTextPrimary,
          side: const BorderSide(color: kTextSecondary),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'I agree to the ',
              style: const TextStyle(color: kTextSecondary, fontSize: 14),
              children: [
                TextSpan(
                  text: 'Terms & Conditions',
                  style: const TextStyle(color: kAccentCyan, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: kCardGlass,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: kAccentCyan.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: kTextPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscureText = false,
    int? maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: kTextPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kTextSecondary),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: kDarkBlue.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white24)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white24)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kAccentCyan, width: 2)),
      ),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) return 'Please fill out this field.';
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required String hint,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      style: const TextStyle(color: kTextPrimary),
      dropdownColor: kDarkBlue.withOpacity(0.9),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kTextSecondary),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: kDarkBlue.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white24)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white24)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kAccentCyan, width: 2)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please select an option.';
        return null;
      },
    );
  }
}