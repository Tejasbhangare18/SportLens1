import 'package:flutter/material.dart';

// --- UI Constants for consistent styling ---
const Color kDarkBlue = Color(0xFF1A2531);
const Color kFieldColor = Color(0xFF2A3A4A);
const Color kAccentBlue = Color(0xFF4A90E2);

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // --- Controllers for all the form fields ---
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _coachController;
  late TextEditingController _clubController;
  
  // State for dropdowns
  String? _gender;
  String? _sport;
  String? _experience;

  // State for the dynamic list of achievements
  late List<TextEditingController> _achievementControllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with some mock data
    _nameController = TextEditingController(text: 'Ethan Carter');
    _usernameController = TextEditingController(text: '@ethan_carter');
    _emailController = TextEditingController(text: 'ethan.carter@example.com');
    _phoneController = TextEditingController(text: '+1 (555) 123-4567');
    _dobController = TextEditingController(text: '05/22/1998');
    _coachController = TextEditingController(text: 'Sarah Jones');
    _clubController = TextEditingController(text: 'Golden State Warriors');
    
    _gender = 'Male';
    _sport = 'Basketball';
    _experience = 'Beginner';

    _achievementControllers = [
      TextEditingController(text: '2023 Regional MVP'),
      TextEditingController(text: "State Championship Winner '22"),
    ];
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _coachController.dispose();
    _clubController.dispose();
    for (var controller in _achievementControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _addAchievement() {
    setState(() {
      _achievementControllers.add(TextEditingController());
    });
  }

  void _removeAchievement(int index) {
    setState(() {
      _achievementControllers[index].dispose();
      _achievementControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            // --- Profile Picture with Edit Icon ---
            _buildProfilePicture(),
            const SizedBox(height: 30),

            // --- Form Fields ---
            _buildTextField(label: 'Full Name', controller: _nameController),
            _buildTextField(label: 'Username', controller: _usernameController),
            _buildTextField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
            _buildTextField(label: 'Phone Number', controller: _phoneController, keyboardType: TextInputType.phone),
            _buildTextField(
              label: 'Date of Birth',
              controller: _dobController,
              suffixIcon: Icons.calendar_today_outlined,
              onTap: () async { /* TODO: Show Date Picker */ },
            ),
            _buildDropdownField(label: 'Gender', value: _gender, items: ['Male', 'Female', 'Other'], onChanged: (v) => setState(() => _gender = v)),
            _buildDropdownField(label: 'Sport Specialization', value: _sport, items: ['Basketball', 'Soccer', 'Baseball'], onChanged: (v) => setState(() => _sport = v)),
            _buildDropdownField(label: 'Experience Level', value: _experience, items: ['Beginner', 'Intermediate', 'Advanced', 'Pro'], onChanged: (v) => setState(() => _experience = v)),
            _buildTextField(label: 'Personal Coach', controller: _coachController),
            _buildTextField(label: 'Club Association', controller: _clubController),
            
            // --- Achievements Section ---
            _buildAchievementsSection(),
            const SizedBox(height: 30),

            // --- Bottom Buttons ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: kFieldColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () { /* TODO: Save changes */ Navigator.of(context).pop(); },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets for Building UI Components ---

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        const CircleAvatar(radius: 56, backgroundImage: AssetImage('assets/user_avatar.png')),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () { /* TODO: Handle image picking */ },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: kAccentBlue, shape: BoxShape.circle),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onTap: onTap,
          readOnly: onTap != null,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: kFieldColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.white54, size: 20) : null,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          dropdownColor: kFieldColor,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: kFieldColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Achievements', style: TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        ...List.generate(_achievementControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _achievementControllers[index],
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kFieldColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white54),
                  onPressed: () => _removeAchievement(index),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _addAchievement,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: kFieldColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 1.5, style: BorderStyle.solid), // Dashed border is complex, using solid
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add, color: kAccentBlue),
                SizedBox(width: 8),
                Text('Add Achievement', style: TextStyle(color: kAccentBlue, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}