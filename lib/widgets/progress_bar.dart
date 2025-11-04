import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const ProgressBar({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: current / total,
          backgroundColor: Colors.white10,
          color: Colors.deepPurpleAccent,
        ),
        const SizedBox(height: 8),
        Text('Pertanyaan $current dari $total', style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
