import 'package:flutter/material.dart';

// Centralized theme for trial pages
const Color kTrialBackground = Color(0xFF121B26); // deep navy
const Color kPrimaryAccent = Color(0xFF348AFF); // bright blue
const Color kGrey800 = Color(0xFF272B33);
const Color kGrey900 = Color(0xFF20222B);
const double kCardRadius = 14.0;
const double kFieldRadius = 16.0;

BoxDecoration kCardDecoration({Color? color}) {
  return BoxDecoration(
    color: (color ?? kGrey900),
    borderRadius: BorderRadius.circular(kCardRadius),
    boxShadow: [
      BoxShadow(
        color: kPrimaryAccent.withOpacity(0.06),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

InputDecoration kSearchFieldDecoration({String? hint}) {
  return InputDecoration(
    hintText: hint ?? 'Search',
    hintStyle: const TextStyle(color: Colors.white54),
    prefixIcon: const Icon(Icons.search, color: Colors.white54),
    filled: true,
    fillColor: kGrey900,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kFieldRadius),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  );
}

ButtonStyle kPrimaryButtonStyle({double radius = kCardRadius}) {
  return ElevatedButton.styleFrom(
    backgroundColor: kPrimaryAccent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    elevation: 0,
  );
}
