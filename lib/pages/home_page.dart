import 'package:flutter/material.dart';
import 'quiz_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const HomePage({super.key, required this.onToggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedQuestions = 10;
  String _selectedCategory = 'Umum';
  bool _isTimed = false;
  int _timeLimit = 1; // menit default

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                      color: textColor,
                      size: 28,
                    ),
                    onPressed: widget.onToggleTheme,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1F26) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.quiz_rounded, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Kuis Edukasi Interaktif',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Uji pengetahuanmu dengan berbagai pertanyaan menarik dan tantangan waktu!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: subTextColor),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Masukkan Nama Anda',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Nama lengkap...',
                          hintStyle: TextStyle(color: subTextColor),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF2A2F36) : Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            final name = _nameController.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Mohon masukkan nama Anda')),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizPage(
                                  userName: name,
                                  totalQuestions: _selectedQuestions,
                                  category: _selectedCategory,
                                  isTimed: _isTimed,
                                  timeLimit: _timeLimit, // ✅ tambahan
                                  onToggleTheme: widget.onToggleTheme,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Mulai Kuis',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 22),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOptionCard(
                              'Pertanyaan',
                              '$_selectedQuestions',
                              isDark,
                              textColor,
                                  () => _showQuestionSelector(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildOptionCard(
                              'Kategori',
                              _selectedCategory,
                              isDark,
                              textColor,
                                  () => _showCategorySelector(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildOptionCard(
                        'Mode Waktu',
                        _isTimed ? 'Terbatas (${_timeLimit}m)' : 'Bebas',
                        isDark,
                        textColor,
                            () async {
                          if (_isTimed) {
                            setState(() => _isTimed = false);
                          } else {
                            final controller = TextEditingController();
                            final result = await showDialog<int>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Masukkan waktu (menit)'),
                                  content: TextField(
                                    controller: controller,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Contoh: 5',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final value = int.tryParse(controller.text);
                                        if (value != null && value > 0) {
                                          Navigator.pop(context, value);
                                        }
                                      },
                                      child: const Text('Simpan'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (result != null) {
                              setState(() {
                                _isTimed = true;
                                _timeLimit = result;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
      String label,
      String value,
      bool isDark,
      Color textColor,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2F36) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600])),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor)),
          ],
        ),
      ),
    );
  }

  void _showQuestionSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildBottomSheet(
          'Pilih Jumlah Pertanyaan',
          [5, 10, 15, 20].map((num) => '$num Pertanyaan').toList(),
              (index) {
            setState(() => _selectedQuestions = [5, 10, 15, 20][index]);
          },
        );
      },
    );
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return _buildBottomSheet(
          'Pilih Kategori',
          ['Umum', 'Geografi', 'Sejarah', 'Sains', 'Teknologi'],
              (index) {
            setState(() =>
            _selectedCategory = ['Umum', 'Geografi', 'Sejarah', 'Sains', 'Teknologi'][index]);
          },
        );
      },
    );
  }

  Widget _buildBottomSheet(
      String title, List<String> items, Function(int) onSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        children: [
          Center(
            child: Text(title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          ...items.asMap().entries.map((entry) {
            return ListTile(
              title: Text(entry.value),
              onTap: () {
                onSelected(entry.key);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
