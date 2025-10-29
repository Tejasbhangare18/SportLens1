import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'registration_success_page.dart';

// --- Modern Gradient Glow Theme ---
const Color kDarkBlue = Color(0xFF0F2027);
const Color kCardGlass = Color(0x1AFFFFFF);
const Color kAccentCyan = Color(0xFF00A8E8);
const Color kTextPrimary = Colors.white;
const Color kTextSecondary = Colors.white70;

class PlayerRegistrationPage extends StatefulWidget {
  const PlayerRegistrationPage({super.key});

  @override
  State<PlayerRegistrationPage> createState() => _PlayerRegistrationPageState();
}

class _PlayerRegistrationPageState extends State<PlayerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _positionController = TextEditingController();

  String? _selectedSport;
  String? _selectedGender;
  bool _useEmail = true;
  bool _otpSent = false;
  bool _otpVerified = false;
  bool _agree = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if ((_useEmail && _emailController.text.isNotEmpty) ||
        (!_useEmail && _phoneController.text.isNotEmpty)) {
      setState(() => _otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully (demo).')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email or phone number.')),
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

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
      setState(() => _dobController.text = formattedDate);
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
        MaterialPageRoute(builder: (context) => const RegistrationSuccessPage()),
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
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
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
              leading: BackButton(color: kTextPrimary),
              centerTitle: true,
              title: Text(
                'Player Registration',
                style: TextStyle(
                  color: kTextPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: kAccentCyan,
                        child: Icon(Icons.person, color: kTextPrimary, size: 40),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Create your athlete profile',
                        style: TextStyle(color: kTextSecondary, fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionCard(
                        title: 'Personal Information',
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(controller: _firstNameController, label: 'First Name'),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(controller: _lastNameController, label: 'Last Name'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    controller: _dobController,
                                    label: 'Date of Birth',
                                    hint: 'dd/mm/yyyy',
                                    readOnly: true,
                                    onTap: _selectDate,
                                    suffixIcon: const Icon(Icons.calendar_today_outlined, color: kTextSecondary),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDropdownField(
                                    value: _selectedGender,
                                    label: 'Gender',
                                    hint: 'Select',
                                    items: ['Male', 'Female', 'Other'],
                                    onChanged: (value) => setState(() => _selectedGender = value),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildOtpVerification(),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(controller: _passwordController, label: 'Password', obscureText: true),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    controller: _confirmPasswordController,
                                    label: 'Confirm Password',
                                    obscureText: true,
                                    validator: (value) {
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionCard(
                        title: 'Sports Profile',
                        child: Column(
                          children: [
                            _buildDropdownField(
                              value: _selectedSport,
                              label: 'Primary Sport',
                              hint: 'Select your sport',
                              items: ['Cricket', 'Football', 'Basketball', 'Tennis'],
                              onChanged: (value) => setState(() => _selectedSport = value),
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _positionController,
                              label: 'Position/Role',
                              hint: 'e.g., Point Guard, Striker, etc.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildTermsAndConditions(),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _createAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccentCyan,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 8,
                            shadowColor: kAccentCyan.withOpacity(0.5),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kTextPrimary),
                          ),
                        ),
                      ),
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
              onChanged: (value) => setState(() => _useEmail = value!),
              activeColor: kAccentCyan,
            ),
            Text('Email', style: TextStyle(color: _useEmail ? kTextPrimary : kTextSecondary)),
            Radio<bool>(
              value: false,
              groupValue: _useEmail,
              onChanged: (value) => setState(() => _useEmail = value!),
              activeColor: kAccentCyan,
            ),
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
                style: ElevatedButton.styleFrom(backgroundColor: kAccentCyan, padding: const EdgeInsets.symmetric(vertical: 14)),
                child: Text(_otpSent ? 'Resend' : 'OTP'),
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
                  child: Text(_otpVerified ? 'Verified' : 'Verify'),
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
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: kCardGlass,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: kTextPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
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
    bool readOnly = false,
    int? maxLines = 1,
    TextInputType? keyboardType,
    Icon? suffixIcon,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onTap: onTap,
      style: const TextStyle(color: kTextPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kTextSecondary),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: kDarkBlue.withOpacity(0.4),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kAccentCyan, width: 2),
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill out this field.';
            }
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
      items: items.map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(value: val, child: Text(val));
      }).toList(),
      style: const TextStyle(color: kTextPrimary),
      dropdownColor: kDarkBlue.withOpacity(0.9),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kTextSecondary),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: kDarkBlue.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kAccentCyan, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an option.';
        }
        return null;
      },
    );
  }
}
