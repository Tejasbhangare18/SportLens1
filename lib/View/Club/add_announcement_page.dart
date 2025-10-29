import 'package:flutter/material.dart';
import 'dart:ui';

class AddAnnouncementPage extends StatefulWidget {
  const AddAnnouncementPage({super.key});

  @override
  State<AddAnnouncementPage> createState() => _AddAnnouncementPageState();
}

class _AddAnnouncementPageState extends State<AddAnnouncementPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _message = '';
  DateTime? _scheduledDate;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D111C), // matches your app’s dark tone
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Add Announcement',
          style: TextStyle(
            color: Color(0xFF00A8E8),
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGlassField(
                label: "Title",
                hint: "Enter headline or subject",
                onChanged: (v) => setState(() => _title = v),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title required' : null,
              ),
              const SizedBox(height: 20),
              _buildGlassField(
                label: "Message",
                hint: "Write details or announcement content",
                onChanged: (v) => setState(() => _message = v),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Message required' : null,
                maxLines: 6,
              ),
              const SizedBox(height: 20),
              _buildDatePicker(context),
              const SizedBox(height: 30),
              _buildGlowingButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Glass Field
  Widget _buildGlassField({
    required String label,
    required String hint,
    required ValueChanged<String> onChanged,
    required FormFieldValidator<String> validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1B2231).withOpacity(0.9),
                const Color(0xFF111520).withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00A8E8).withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            maxLines: maxLines,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Date Picker Styled as Card
  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now.subtract(const Duration(days: 1)),
          lastDate: now.add(const Duration(days: 365)),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF00A8E8),
                surface: Color(0xFF1B2231),
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) {
          setState(() => _scheduledDate = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1B2231).withOpacity(0.9),
              const Color(0xFF111520).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00A8E8).withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _scheduledDate == null
                  ? "Select Schedule Date"
                  : "${_scheduledDate!.day}/${_scheduledDate!.month}/${_scheduledDate!.year}",
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const Icon(Icons.date_range_rounded,
                color: Color(0xFF00A8E8), size: 22),
          ],
        ),
      ),
    );
  }

  // 🔹 Glowing Submit Button
  Widget _buildGlowingButton(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A8E8).withOpacity(0.5),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A8E8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: _isLoading
            ? null
            : () async {
                if (!_formKey.currentState!.validate()) return;
                setState(() => _isLoading = true);
                await Future.delayed(const Duration(seconds: 1));
                setState(() => _isLoading = false);
                Navigator.pop(context, {
                  'title': _title.trim(),
                  'message': _message.trim(),
                  'scheduled': _scheduledDate,
                });
              },
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child:
                    CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : const Text(
                "Post Announcement",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
