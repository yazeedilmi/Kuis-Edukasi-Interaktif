import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final Function(String) onOptionSelected;

  const QuestionCard({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.onOptionSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              questionText,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 30),
            ...options.map((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onOptionSelected(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      option,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
