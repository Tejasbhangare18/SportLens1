import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';







class EditClubProfilePage extends StatefulWidget {
  final String name;
  final String description;
  final String year;
  final String email;
  final String phone;
  final String location;

  const EditClubProfilePage({
    super.key,
    required this.name,
    required this.description,
    required this.year,
    required this.email,
    required this.phone,
    required this.location,
  });

  @override
  State<EditClubProfilePage> createState() => _EditClubProfilePageState();
}

class _EditClubProfilePageState extends State<EditClubProfilePage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController yearController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locationController;

  List<String> clubPhotos = [
    'https://images.unsplash.com/photo-1507537509458-b8312d33e49a',
    'https://images.unsplash.com/photo-1517649763962-0c623066013b',
    'https://images.unsplash.com/photo-1494526585095-c41746248156',
  ];

  List<String> achievements = [
    'Winner of Regional Championship 2023',
    'Best Youth Development 2022',
    '3-time National Finalists',
  ];

  late PageController _photosController;
  late PageController _achievementsController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    descriptionController = TextEditingController(text: widget.description);
    yearController = TextEditingController(text: widget.year);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    locationController = TextEditingController(text: widget.location);
    _photosController = PageController();
    _achievementsController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    yearController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    _photosController.dispose();
    _achievementsController.dispose();
    super.dispose();
  }

  Future<String?> _showEditDialog(String title, String initialValue) async {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Enter here...'),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _addPhoto() {
    _pickFromGallery();
  }

  Future<void> _pickFromGallery() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      setState(() {
        clubPhotos.add(filePath);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error picking image: $e')),
    );
  }
}


  void _addAchievement() async {
    final newAch = await _showEditDialog('Add Achievement', '');
    if (newAch != null && newAch.isNotEmpty) {
      setState(() {
        achievements.add(newAch);
      });
    }
  }

  void _editAchievement(int index) async {
    final newText = await _showEditDialog(
      'Edit Achievement',
      achievements[index],
    );
    if (newText != null && newText.isNotEmpty) {
      setState(() {
        achievements[index] = newText;
      });
    }
  }

  Future<void> _deletePhoto(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete photo'),
            content: const Text('Are you sure you want to delete this photo?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() {
        clubPhotos.removeAt(index);
      });

      // Adjust page controller to a valid page if needed
      if (_photosController.hasClients) {
        final current = _photosController.page?.round() ?? 0;
        final target =
            (current >= clubPhotos.length) ? (clubPhotos.length - 1) : current;
        if (target >= 0) {
          _photosController.animateToPage(
            target,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Photo deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF121212);
    const cardColor = Color(0xFF1E1E1E);
    const sectionTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text(
          'Edit Club Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Photos carousel with add photo button
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _photosController,
                  itemCount: clubPhotos.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(clubPhotos[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Small delete icon at bottom-left of the photo
                        Positioned(
                          right: 20,
                          bottom: 20,
                          child: Material(
                            color: Colors.black45,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => _deletePhoto(index),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  right: 16,
                  top: 16,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: _addPhoto,
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SmoothPageIndicator(
              controller: _photosController,
              count: clubPhotos.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: Colors.blueAccent,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Editable club description below photos
          TextField(
            controller: descriptionController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Club Description',
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: 24),

          // Achievements carousel with add/edit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Achievements', style: sectionTextStyle),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.blueAccent,
                  size: 30,
                ),
                onPressed: _addAchievement,
                tooltip: 'Add Achievement',
              ),
            ],
          ),
          SizedBox(
            height: 120,
            child: PageView.builder(
              controller: _achievementsController,
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _editAchievement(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        achievements[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Editable Location
          TextField(
            controller: locationController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Club Location',
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Editable Email
          TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Editable Phone
          TextField(
            controller: phoneController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Phone',
              labelStyle: const TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
            ),
          ),

          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: () {
              // Add your save logic here, send updated data to backend or state

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );

              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}

class FileType {
  static get image => null;
}

class FilePicker {
  static get platform => null;
}
