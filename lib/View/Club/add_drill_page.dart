import 'package:flutter/material.dart';
import 'drills_repository.dart';

class AddDrillPage extends StatefulWidget {
  const AddDrillPage({Key? key}) : super(key: key);

  @override
  State<AddDrillPage> createState() => _AddDrillPageState();
}

class _AddDrillPageState extends State<AddDrillPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController drillNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  // venue removed per request
  final TextEditingController descriptionController = TextEditingController();

  String selectedSport = 'Select Sport';
  final List<String> sportTypes = ['Cricket', 'Football', 'Basketball'];

  String selectedSkill = 'Select Skill Level';
  final List<String> skillLevels = ['Beginner', 'Intermediate', 'Advanced'];

  DateTime? _dateFrom;
  DateTime? _dateTo;

  String _formatDate(DateTime dt) =>
      "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16181E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16181E),
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Add Challenge',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field(
                  child: TextFormField(
                    controller: drillNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoration('Challenge Name'),
                  ),
                ),
                _field(
                  child: DropdownButtonFormField<String>(
                    value:
                        selectedSport == 'Select Sport' ? null : selectedSport,
                    dropdownColor: const Color(0xFF22252B),
                    iconEnabledColor: Colors.white,
                    items: [
                      DropdownMenuItem(
                        enabled: false,
                        child: Text(
                          'Select Sport',
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
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
                      setState(() => selectedSport = val ?? 'Select Sport');
                    },
                    decoration: _decoration('Sport'),
                  ),
                ),
                _field(
                  child: DropdownButtonFormField<String>(
                    value:
                        selectedSkill == 'Select Skill Level'
                            ? null
                            : selectedSkill,
                    dropdownColor: const Color(0xFF22252B),
                    iconEnabledColor: Colors.white,
                    items: [
                      DropdownMenuItem(
                        enabled: false,
                        child: Text(
                          'Select Skill Level',
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...skillLevels.map(
                        (level) => DropdownMenuItem(
                          value: level,
                          child: Text(
                            level,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(
                        () => selectedSkill = val ?? 'Select Skill Level',
                      );
                    },
                    decoration: _decoration('Skill Level'),
                  ),
                ),
                _field(
                  child: TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () async {
                      final now = DateTime.now();
                      final pickedFrom = await showDatePicker(
                        context: context,
                        initialDate: _dateFrom ?? now,
                        firstDate: now,
                        lastDate: DateTime(now.year + 2),
                      );
                      if (pickedFrom != null) {
                        final pickedTo = await showDatePicker(
                          context: context,
                          initialDate: pickedFrom.add(const Duration(days: 1)),
                          firstDate: pickedFrom,
                          lastDate: DateTime(now.year + 2),
                        );
                        if (pickedTo != null) {
                          setState(() {
                            _dateFrom = pickedFrom;
                            _dateTo = pickedTo;
                            dateController.text =
                                '${_formatDate(pickedFrom)} - ${_formatDate(pickedTo)}';
                          });
                        }
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoration('Challenge Date (From - To)'),
                  ),
                ),
                _field(
                  child: TextFormField(
                    controller: timeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _decoration('Time'),
                  ),
                ),
                _field(
                  child: TextFormField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 4,
                    decoration: _decoration('Description'),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if ((_formKey.currentState?.validate() ?? false) &&
                          _dateFrom != null &&
                          _dateTo != null) {
                        final id =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        final newDrill = {
                          'id': id,
                          'title': drillNameController.text.trim(),
                          'sport': selectedSport,
                          'skill': selectedSkill,
                          'dateFrom': _dateFrom!.toIso8601String(),
                          'dateTo': _dateTo!.toIso8601String(),
                          'dateLabel': dateController.text,
                          'time': timeController.text.trim(),
                          'description': descriptionController.text.trim(),
                          'players': <Map<String, dynamic>>[],
                        };
                        DrillsRepository.instance.addDrill(newDrill);

                        // Show confirmation dialog and, when user confirms, close the Add page
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                backgroundColor: const Color(0xFF23252B),
                                title: const Text(
                                  'Challenge Saved',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  'The challenge has been added to ongoing challenges.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                        );

                        if (confirmed == true) {
                          // Close the AddDrillPage to return to the previous screen so the user
                          // can immediately see the drill in the ongoing list (ValueNotifier updates UI).
                          Navigator.of(context).pop();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a date range'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Challenge',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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

  Widget _field({required Widget child}) =>
      Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: child);

  InputDecoration _decoration(String label) => InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(color: Colors.white54),
    filled: true,
    fillColor: const Color(0xFF23252B),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
  );
}
