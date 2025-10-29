import 'package:flutter/material.dart';
import 'trials_theme.dart';

class EditTrialPage extends StatefulWidget {
  final Map<String, dynamic>? initialTrialData;

  const EditTrialPage({Key? key, this.initialTrialData}) : super(key: key);

  @override
  State<EditTrialPage> createState() => _EditTrialPageState();
}

class _EditTrialPageState extends State<EditTrialPage> {
  late TextEditingController trialNameController;
  late TextEditingController dateRangeController;
  late TextEditingController timeController;
  late TextEditingController locationController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;

  final Color primaryColor = kPrimaryAccent;
  final Color backgroundColor = kTrialBackground;
  final Color fieldFillColor = kGrey800;

  @override
  void initState() {
    super.initState();
    trialNameController = TextEditingController(
      text: widget.initialTrialData?['title'] ?? '',
    );
    dateRangeController = TextEditingController(
      text: widget.initialTrialData?['date'] ?? '',
    );
    timeController = TextEditingController(
      text: widget.initialTrialData?['time'] ?? '',
    );
    locationController = TextEditingController(
      text: widget.initialTrialData?['location'] ?? '',
    );
    addressController = TextEditingController(
      text: widget.initialTrialData?['address'] ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.initialTrialData?['description'] ?? '',
    );
  }

  @override
  void dispose() {
    trialNameController.dispose();
    dateRangeController.dispose();
    timeController.dispose();
    locationController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    TimeOfDay initialTime = TimeOfDay.now();
    if (timeController.text.isNotEmpty) {
      try {
        final parts = timeController.text.split(':');
        if (parts.length == 2) {
          int hour = int.parse(parts[0]);
          int minute = int.parse(parts[1]);
          initialTime = TimeOfDay(hour: hour, minute: minute);
        }
      } catch (_) {
        // ignore parsing errors and default to now
      }
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: backgroundColor,
              onSurface: Colors.white70,
            ),
            timePickerTheme: TimePickerThemeData(
              dialHandColor: primaryColor,
              dialBackgroundColor: Colors.grey[850],
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime =
          picked.hour.toString().padLeft(2, '0') +
          ':' +
          picked.minute.toString().padLeft(2, '0');
      setState(() {
        timeController.text = formattedTime;
      });
    }
  }

  void _saveChanges() {
    final updatedTrial = {
      'title': trialNameController.text.trim(),
      'date': dateRangeController.text.trim(),
      'time': timeController.text.trim(),
      'location': locationController.text.trim(),
      'address': addressController.text.trim(),
      'description': descriptionController.text.trim(),
      'imageAsset':
          widget.initialTrialData?['imageAsset'] ?? 'assets/images/soccer.png',
      'applicants': widget.initialTrialData?['applicants'] ?? [],
    };

    Navigator.of(context).pop(updatedTrial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Edit Trial',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Trial Name'),
                _textField(trialNameController),
                _fieldLabel('Date Range'),
                _textField(dateRangeController),
                _fieldLabel('Time'),
                GestureDetector(
                  onTap: _selectTime,
                  child: AbsorbPointer(child: _textField(timeController)),
                ),
                _fieldLabel('Location'),
                _textField(locationController),
                _fieldLabel('Address'),
                _textField(addressController),
                _fieldLabel('Description'),
                _textField(descriptionController, maxLines: 4, minLines: 4),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white70,
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
    );
  }

  Widget _fieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );

  Widget _textField(
    TextEditingController controller, {
    int maxLines = 1,
    int minLines = 1,
  }) => TextField(
    controller: controller,
    maxLines: maxLines,
    minLines: minLines,
    cursorColor: Colors.white,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: fieldFillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    ),
  );
}
