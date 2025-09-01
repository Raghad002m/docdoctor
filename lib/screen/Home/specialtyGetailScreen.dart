import 'package:flutter/material.dart';
import '../DoctorListScreen.dart';


class SpecialtyDetailScreen extends StatelessWidget {
  final String label;
  final String iconPath;

  const SpecialtyDetailScreen({
    required this.label,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
    );
  }
}
