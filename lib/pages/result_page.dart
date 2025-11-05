import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ResultPage extends StatelessWidget {
  final String userName;
  final int score;
  final int total;
  final List<Map<String, dynamic>> userAnswers;
  final VoidCallback onToggleTheme;

  const ResultPage({
    super.key,
    required this.userName,
    required this.score,
    required this.total,
    required this.userAnswers,
    required this.onToggleTheme,
  });

  // Fungsi untuk mendapatkan pesan berdasarkan persentase
  String _getCongratulatoryMessage(double percentage) {
    if (percentage < 30) {
      return 'Belajar Lagi Ya, $userName! 📚';
    } else if (percentage < 50) {
      return 'Kamu Lumayan Juga Ya, $userName! 👍';
    } else if (percentage < 80) {
      return 'Wow Kamu Hebat, $userName! 🌟';
    } else {
      return 'Wow Kamu Sangat Hebat, $userName!\nMama Kamu Pasti Bangga! 🏆';
    }
  }

  // Fungsi untuk mendapatkan emoji berdasarkan persentase
  String _getEmoji(double percentage) {
    if (percentage < 30) {
      return '📚';
    } else if (percentage < 50) {
      return '👍';
    } else if (percentage < 80) {
      return '🌟';
    } else {
      return '🏆';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = (score / total) * 100;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hasil Kuis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: onToggleTheme,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Score Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1F26) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      _getCongratulatoryMessage(percentage),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Skor Kamu:',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$score / $total',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // List of answers
              Expanded(
                child: ListView.builder(
                  itemCount: userAnswers.length,
                  itemBuilder: (context, index) {
                    final item = userAnswers[index];
                    final isCorrect = item['isCorrect'] as bool;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? (isCorrect
                            ? Colors.green.withOpacity(0.15)
                            : Colors.red.withOpacity(0.15))
                            : (isCorrect
                            ? Colors.green[50]
                            : Colors.red[50]),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                          isCorrect ? Colors.green : Colors.redAccent,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${index + 1}. ${item['question']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                              isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Jawaban kamu: ${item['userAnswer']}',
                            style: TextStyle(
                              color: isCorrect
                                  ? Colors.green
                                  : Colors.redAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!isCorrect)
                            Text(
                              'Jawaban benar: ${item['correctAnswer']}',
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Tombol Aksi
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding:
                        const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Kembali ke Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // ✅ Tombol Bagikan
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final message =
                            '🎯 Hasil Kuis-ku di Aplikasi Kuis Hebat!\n\n'
                            'Nama: $userName\n'
                            'Skor: $score dari $total pertanyaan '
                            '(${percentage.toStringAsFixed(1)}%)\n\n'
                            'Ayo coba dan kalahkan skorku! 💪';
                        Share.share(message);
                      },
                      icon: const Icon(Icons.share, color: Colors.deepPurple),
                      label: const Text(
                        'Bagikan Hasil',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.deepPurple),
                        padding:
                        const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}