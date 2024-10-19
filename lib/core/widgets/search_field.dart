import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const SearchField({super.key, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    );
  }
}
