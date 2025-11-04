import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const OptionButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white10,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
