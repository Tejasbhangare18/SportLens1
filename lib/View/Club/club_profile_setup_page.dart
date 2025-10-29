import 'package:flutter/material.dart';

class ClubProfileSetupPage extends StatefulWidget {
  final VoidCallback onSaveProfile;
  final VoidCallback onBack;

  const ClubProfileSetupPage({
    super.key,
    required this.onSaveProfile,
    required this.onBack,
  });

  @override
  State<ClubProfileSetupPage> createState() => _ClubProfileSetupPageState();
}

class _ClubProfileSetupPageState extends State<ClubProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF348AFF);
    final backgroundColor = const Color(0xFF121B26);
    final cardColor = const Color(0xFF1F2A40);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        leading: BackButton(color: Colors.white70, onPressed: widget.onBack),
        title: const Text(
          'Club Profile Setup',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                _inputField(
                  controller: _addressController,
                  label: 'Club Address',
                  validatorMsg: 'Enter your club address',
                ),
                const SizedBox(height: 18),
                _inputField(
                  controller: _phoneController,
                  label: 'Contact Number',
                  keyboardType: TextInputType.phone,
                  validatorMsg: 'Enter a valid number',
                  minLength: 10,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                    shadowColor: Colors.blueAccent.shade700,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSaveProfile();
                    }
                  },
                  child: const Text(
                    'Save & Continue',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String validatorMsg,
    TextInputType keyboardType = TextInputType.text,
    int? minLength,
  }) {
    final primaryColor = const Color(0xFF348AFF);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) return validatorMsg;
            if (minLength != null && value.length < minLength)
              return validatorMsg;
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF283843),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: primaryColor.withOpacity(0.9),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
