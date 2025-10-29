import 'package:flutter/material.dart';
import 'invite_players_page.dart';
// Note: I've removed the 'trials_theme.dart' import and defined
// the colors locally so this file is self-contained.

class NewTrialPage extends StatefulWidget {
  const NewTrialPage({Key? key}) : super(key: key);

  @override
  State<NewTrialPage> createState() => _NewTrialPageState();
}

class _NewTrialPageState extends State<NewTrialPage> {
  // --- NEW: Modern Color Palette ---
  static const Color kDarkBackground = Color(0xFF121B26);
  static const Color kFieldBackground = Color(0xFF1B2231);
  static const Color kPrimaryAccent = Colors.blueAccent;
  static const Color kSuccessAccent = Colors.greenAccent;

  // --- All controllers and lists are unchanged ---
  final _formKey = GlobalKey<FormState>();
  final TextEditingController trialNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController venueController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController maxParticipantsController =
      TextEditingController();
  final TextEditingController ageSkillController = TextEditingController();

  String selectedSportType = 'Sport Type';
  final List<String> sportTypes = ['Cricket', 'Football', 'Basketball'];

  final List<String> commonAges = [
    'Under 13', 'Under 15', 'Under 17', 'Under 19',
    '16-18', '18-25', 'Open Age',
  ];

  final List<String> timeSlots = [
    '07:00 AM', '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM',
  ];

  DateTime? _dateFrom;

  @override
  void dispose() {
    trialNameController.dispose();
    dateController.dispose();
    timeController.dispose();
    venueController.dispose();
    descriptionController.dispose();
    maxParticipantsController.dispose();
    ageSkillController.dispose();
    super.dispose();
  }

  // --- Picker functions are unchanged, but colors are updated ---

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    DateTime? from = _dateFrom ?? now;
    final pickedFrom = await showDatePicker(
      context: context,
      initialDate: from,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      helpText: 'Select start date',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: kPrimaryAccent, // NEW: Use theme color
            surface: kFieldBackground, // NEW: Use theme color
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (pickedFrom != null) {
      final pickedTo = await showDatePicker(
        context: context,
        initialDate: pickedFrom.add(const Duration(days: 1)),
        firstDate: pickedFrom,
        lastDate: DateTime(now.year + 2),
        helpText: 'Select end date',
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: kPrimaryAccent, // NEW: Use theme color
              surface: kFieldBackground, // NEW: Use theme color
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        ),
      );
      if (pickedTo != null) {
        setState(() {
          _dateFrom = pickedFrom;
          dateController.text =
              '${_formatDate(pickedFrom)} - ${_formatDate(pickedTo)}';
        });
      }
    }
  }

  String _formatDate(DateTime dt) =>
      "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";

  Future<void> _pickTimeSlot() async {
    String? selected;
    await showModalBottomSheet(
      context: context,
      backgroundColor: kFieldBackground, // NEW: Use theme color
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  "Select Time Slot",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...timeSlots.map(
              (slot) => ListTile(
                title: Text(
                  slot,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  selected = slot;
                  Navigator.of(context).pop();
                },
                selected: slot == timeController.text,
                selectedTileColor: kPrimaryAccent.withOpacity(0.2), // NEW
                shape: RoundedRectangleBorder( // NEW
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      setState(() {
        timeController.text = selected!;
      });
    }
  }

  Future<void> _showAgePicker() async {
    final initial = ageSkillController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final Set<String> selected = {...initial};
    String customValue = '';

    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: kFieldBackground, // NEW: Use theme color
              title: const Text(
                'Select Age Groups',
                style: TextStyle(color: Colors.white),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...commonAges.map((age) {
                      return CheckboxListTile(
                        value: selected.contains(age),
                        onChanged: (v) => setState(() {
                          if (v == true)
                            selected.add(age);
                          else
                            selected.remove(age);
                        }),
                        title: Text(
                          age,
                          style: const TextStyle(color: Colors.white),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: kPrimaryAccent, // NEW
                        checkColor: kFieldBackground, // NEW
                        tileColor: kDarkBackground, // NEW
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: (v) => customValue = v,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a custom age (e.g. 20-25)',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: kDarkBackground, // NEW
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryAccent, // NEW
                        ),
                        onPressed: () {
                          final v = customValue.trim();
                          if (v.isNotEmpty) {
                            setState(() {
                              selected.add(v);
                              customValue = '';
                            });
                          }
                        },
                        child: const Text('Add Custom'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(selected.toList()),
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        ageSkillController.text = result.join(', ');
      });
    }
  }

  void _submitForm() {
    // --- Unchanged ---
    if (_formKey.currentState?.validate() ?? false) {
      final newTrial = {
        'title': trialNameController.text.trim(),
        'date': dateController.text.trim(),
        'time': timeController.text.trim(),
        'location': venueController.text.trim(),
        'description': descriptionController.text.trim(),
        'maxParticipants': maxParticipantsController.text.trim(),
        'ageSkill': ageSkillController.text.trim(),
        'sportType':
            selectedSportType != 'Sport Type' ? selectedSportType : null,
        'imageAsset': 'assets/images/soccer.png', // default
        'applicants': [],
      };
      Navigator.of(context).pop(newTrial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground, // NEW
      appBar: AppBar(
        backgroundColor: kDarkBackground, // NEW
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'New Trial',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // NEW: Padding moved here for better scroll behavior
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Form fields are now in Padding widgets, not a helper ---
              _buildField(
                child: TextFormField(
                  controller: trialNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Trial Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter trial name' : null,
                ),
              ),

              _buildField(
                child: DropdownButtonFormField<String>(
                  value:
                      selectedSportType == 'Sport Type' ? null : selectedSportType,
                  dropdownColor: kFieldBackground, // NEW
                  iconEnabledColor: Colors.white,
                  items: [
                    const DropdownMenuItem(
                      enabled: false,
                      child: Text(
                        'Sport Type',
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    ...sportTypes.map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      if (val != null) selectedSportType = val;
                    });
                  },
                  decoration: _decoration('Sport Type'),
                  validator: (val) =>
                      val == null || val == 'Sport Type'
                          ? 'Select a sport type'
                          : null,
                ),
              ),

              _buildField(
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  onTap: _pickDateRange,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Date (From-To)').copyWith(
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white54,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Select a date range'
                          : null,
                ),
              ),

              _buildField(
                child: TextFormField(
                  controller: timeController,
                  readOnly: true,
                  onTap: _pickTimeSlot,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Time').copyWith(
                    suffixIcon: const Icon(
                      Icons.access_time,
                      color: Colors.white54,
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Select a time' : null,
                ),
              ),

              _buildField(
                child: TextFormField(
                  controller: venueController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Venue'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter venue' : null,
                ),
              ),

              _buildField(
                child: TextFormField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 4,
                  decoration: _decoration('Description'),
                ),
              ),

              _buildField(
                child: TextFormField(
                  controller: maxParticipantsController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: _decoration('Max Participants'),
                ),
              ),

              _buildField(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: ageSkillController,
                        style: const TextStyle(color: Colors.white),
                        decoration: _decoration('Age/Skill Requirements'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: kFieldBackground, // NEW
                        borderRadius: BorderRadius.circular(12), // NEW
                      ),
                      child: IconButton(
                        icon:
                            const Icon(Icons.edit_outlined, color: Colors.white70),
                        onPressed: _showAgePicker,
                        tooltip: 'Select multiple ages',
                      ),
                    ),
                  ],
                ),
              ),

              // --- NEW: Styled Section Header ---
              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 12, left: 4),
                child: Text(
                  'Invite Players',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              // --- NEW: Restyled Buttons ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const InvitePlayersPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add, color: Colors.white),
                  label: const Text(
                    'Invite Players',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryAccent, // NEW
                    padding: const EdgeInsets.symmetric(vertical: 16), // NEW
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // NEW
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSuccessAccent, // NEW
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // NEW
                    ),
                  ),
                  child: const Text(
                    'Create Trial',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // NEW: Replaces the old _field helper with simple padding
  Widget _buildField({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }

  // --- NEW: Redesigned Decoration Helper ---
  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label, // CHANGED: from hintText
        labelStyle: const TextStyle(color: Colors.white54), // NEW
        floatingLabelStyle: const TextStyle(color: kPrimaryAccent), // NEW
        filled: true,
        fillColor: kFieldBackground, // NEW
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // NEW
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16), // NEW
      );
}