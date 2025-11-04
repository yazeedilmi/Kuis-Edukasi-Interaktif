import 'package:flutter/material.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final String userName;
  final int totalQuestions;
  final String category;
  final bool isTimed;
  final VoidCallback onToggleTheme;

  const QuizPage({
    super.key,
    required this.userName,
    required this.totalQuestions,
    required this.category,
    required this.isTimed,
    required this.onToggleTheme,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<String, List<Map<String, dynamic>>> _allQuestions = {
    'Geografi': [
      {
        "question": "Apa ibu kota Indonesia?",
        "options": ["Jakarta", "Bandung", "Surabaya", "Medan"],
        "answer": "Jakarta"
      },
      {
        "question": "Gunung tertinggi di Indonesia adalah?",
        "options": ["Gunung Semeru", "Gunung Kerinci", "Puncak Jaya", "Gunung Rinjani"],
        "answer": "Puncak Jaya"
      },
      {
        "question": "Pulau terbesar di Indonesia adalah?",
        "options": ["Jawa", "Sumatra", "Kalimantan", "Papua"],
        "answer": "Papua"
      },
      {
        "question": "Selat yang memisahkan Pulau Jawa dan Sumatra?",
        "options": ["Selat Bali", "Selat Sunda", "Selat Makassar", "Selat Lombok"],
        "answer": "Selat Sunda"
      },
      {
        "question": "Danau terbesar di Indonesia adalah?",
        "options": ["Danau Toba", "Danau Singkarak", "Danau Maninjau", "Danau Poso"],
        "answer": "Danau Toba"
      },
    ],
    'Sejarah': [
      {
        "question": "Siapa presiden pertama Indonesia?",
        "options": ["Soeharto", "Soekarno", "Habibie", "Megawati"],
        "answer": "Soekarno"
      },
      {
        "question": "Kapan Indonesia merdeka?",
        "options": ["17 Agustus 1945", "20 Mei 1908", "28 Oktober 1928", "1 Juni 1945"],
        "answer": "17 Agustus 1945"
      },
      {
        "question": "Siapa yang memproklamasikan kemerdekaan Indonesia?",
        "options": ["Soekarno-Hatta", "Soeharto", "Tan Malaka", "Sjahrir"],
        "answer": "Soekarno-Hatta"
      },
      {
        "question": "Organisasi pemuda yang mengadakan Sumpah Pemuda?",
        "options": ["Budi Utomo", "Jong Java", "Perhimpunan Indonesia", "Semua benar"],
        "answer": "Semua benar"
      },
      {
        "question": "Perang Diponegoro terjadi pada tahun?",
        "options": ["1825-1830", "1830-1835", "1820-1825", "1835-1840"],
        "answer": "1825-1830"
      },
    ],
    'Sains': [
      {
        "question": "Planet terdekat dengan Matahari adalah?",
        "options": ["Venus", "Mars", "Merkurius", "Bumi"],
        "answer": "Merkurius"
      },
      {
        "question": "Rumus kimia air adalah?",
        "options": ["H2O", "CO2", "O2", "NaCl"],
        "answer": "H2O"
      },
      {
        "question": "Berapa jumlah planet dalam tata surya?",
        "options": ["7", "8", "9", "10"],
        "answer": "8"
      },
      {
        "question": "Gas apa yang dihirup manusia untuk bernapas?",
        "options": ["Nitrogen", "Oksigen", "Karbon Dioksida", "Hidrogen"],
        "answer": "Oksigen"
      },
      {
        "question": "Satuan pengukuran suhu adalah?",
        "options": ["Meter", "Kilogram", "Celsius", "Liter"],
        "answer": "Celsius"
      },
    ],
    'Teknologi': [
      {
        "question": "Siapa pendiri Microsoft?",
        "options": ["Steve Jobs", "Bill Gates", "Mark Zuckerberg", "Elon Musk"],
        "answer": "Bill Gates"
      },
      {
        "question": "Bahasa pemrograman untuk Flutter adalah?",
        "options": ["Java", "Dart", "Python", "C++"],
        "answer": "Dart"
      },
      {
        "question": "Siapa pendiri Facebook?",
        "options": ["Bill Gates", "Steve Jobs", "Mark Zuckerberg", "Larry Page"],
        "answer": "Mark Zuckerberg"
      },
      {
        "question": "Apa kepanjangan dari CPU?",
        "options": [
          "Central Processing Unit",
          "Computer Personal Unit",
          "Central Program Unit",
          "Central Processor Upload"
        ],
        "answer": "Central Processing Unit"
      },
      {
        "question": "Sistem operasi yang dikembangkan oleh Apple?",
        "options": ["Windows", "Android", "iOS", "Linux"],
        "answer": "iOS"
      },
    ],
  };

  late List<Map<String, dynamic>> _questions;
  int _currentIndex = 0;
  int _score = 0;
  List<Map<String, dynamic>> _userAnswers = [];
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _prepareQuestions();
  }

  void _prepareQuestions() {
    if (widget.category == '8+') {
      _questions = [];
      _allQuestions.forEach((key, value) {
        _questions.addAll(value);
      });
      _questions.shuffle();
    } else {
      _questions = List.from(_allQuestions[widget.category] ?? []);
    }

    if (_questions.length > widget.totalQuestions) {
      _questions = _questions.sublist(0, widget.totalQuestions);
    }
  }

  void _answerQuestion(String selected) {
    setState(() {
      _selectedAnswer = selected;
    });
  }

  void _nextQuestion() {
    final currentQ = _questions[_currentIndex];
    final isCorrect = _selectedAnswer == currentQ['answer'];

    _userAnswers.add({
      'question': currentQ['question'],
      'userAnswer': _selectedAnswer ?? '',
      'correctAnswer': currentQ['answer'],
      'isCorrect': isCorrect,
    });

    if (isCorrect) _score++;

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            userName: widget.userName,
            score: _score,
            total: _questions.length,
            userAnswers: _userAnswers,
            onToggleTheme: widget.onToggleTheme,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Jika belum ada pertanyaan (kategori salah, dll)
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
        body: const Center(
          child: Text(
            "Tidak ada pertanyaan untuk kategori ini.",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];
    final textColor = isDark ? Colors.white : Colors.black87;
    final subText = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? const Color(0xFF1A1F26) : Colors.grey[100];
    final bgColor = isDark ? const Color(0xFF0F1419) : Colors.white;
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hai, ${widget.userName} 👋',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Pertanyaan ${_currentIndex + 1} dari ${_questions.length}',
                        style: TextStyle(fontSize: 14, color: subText),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: textColor,
                    ),
                    onPressed: widget.onToggleTheme,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey[800],
                  valueColor: const AlwaysStoppedAnimation(Colors.deepPurple),
                ),
              ),
              const SizedBox(height: 24),

              // Card Soal
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge kategori
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Pertanyaan
                      Text(
                        question['question'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Opsi Jawaban
                      Expanded(
                        child: ListView.builder(
                          itemCount: question['options'].length,
                          itemBuilder: (context, index) {
                            final option = question['options'][index];
                            final isSelected = _selectedAnswer == option;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () => _answerQuestion(option),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.deepPurple.withOpacity(0.3)
                                        : (isDark
                                        ? const Color(0xFF2A2F36)
                                        : Colors.grey[200]),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.deepPurple
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Navigasi
              Row(
                children: [
                  if (_currentIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentIndex--;
                            _selectedAnswer = null;
                          });
                        },
                        icon: Icon(Icons.arrow_back, color: textColor),
                        label: Text('Kembali', style: TextStyle(color: textColor)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.deepPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  if (_currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _selectedAnswer != null ? _nextQuestion : null,
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      label: Text(
                        _currentIndex == _questions.length - 1
                            ? 'Selesai'
                            : 'Selanjutnya',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
