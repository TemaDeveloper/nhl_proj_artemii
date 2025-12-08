import 'package:flutter/material.dart';

class StatRow extends StatelessWidget {
  final String label;
  final String awayValue;
  final String homeValue;

  const StatRow({
    super.key,
    required this.label,
    required this.awayValue,
    required this.homeValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              awayValue,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              homeValue,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}