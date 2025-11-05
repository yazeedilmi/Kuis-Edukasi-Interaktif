import 'dart:async';
import 'package:flutter/material.dart';
import 'result_page.dart';

class QuizPage extends StatefulWidget {
  final String userName;
  final int totalQuestions;
  final String category;
  final bool isTimed;
  final int timeLimit;
  final VoidCallback onToggleTheme;

  const QuizPage({
    super.key,
    required this.userName,
    required this.totalQuestions,
    required this.category,
    required this.isTimed,
    required this.timeLimit,
    required this.onToggleTheme,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Timer? _timer;
  int _remainingSeconds = 0;

  final Map<String, List<Map<String, dynamic>>> _allQuestions = {
    'Geografi': [
      {
        'question': 'Apa ibu kota Indonesia?',
        'options': ['Bandung', 'Jakarta', 'Surabaya', 'Medan'],
        'answer': 'Jakarta',
      },
      {
        'question': 'Gunung tertinggi di dunia adalah?',
        'options': ['Kilimanjaro', 'Everest', 'Elbrus', 'Andes'],
        'answer': 'Everest',
      },
      {
        'question': 'Sungai Nil terletak di benua mana?',
        'options': ['Asia', 'Eropa', 'Afrika', 'Amerika Selatan'],
        'answer': 'Afrika',
      },
      {
        'question': 'Laut terbesar di dunia adalah?',
        'options': [
          'Laut Cina Selatan',
          'Laut Mediterania',
          'Laut Karibia',
          'Laut Filipina'
        ],
        'answer': 'Laut Filipina',
      },
      {
        'question': 'Negara mana yang memiliki pulau terbanyak?',
        'options': ['Indonesia', 'Jepang', 'Swedia', 'Filipina'],
        'answer': 'Indonesia',
      },
      {
        'question': 'Pulau terbesar di dunia berdasarkan luas daratan adalah?',
        'options': ['Kalimantan', 'Papua', 'Greenland', 'Madagaskar'],
        'answer': 'Greenland',
      },
      {
        'question': 'Danau Toba terletak di pulau mana?',
        'options': ['Sumatra', 'Jawa', 'Kalimantan', 'Sulawesi'],
        'answer': 'Sumatra',
      },
      {
        'question': 'Selat yang memisahkan Jawa dan Sumatra adalah?',
        'options': ['Selat Sunda', 'Selat Malaka', 'Selat Lombok', 'Selat Makassar'],
        'answer': 'Selat Sunda',
      },
      {
        'question': 'Iklim tropis biasanya memiliki dua musim utama, yaitu?',
        'options': ['Dingin dan Panas', 'Hujan dan Kemarau', 'Empat musim', 'Musim Semi dan Gugur'],
        'answer': 'Hujan dan Kemarau',
      },
      {
        'question': 'Benua terkecil di dunia adalah?',
        'options': ['Eropa', 'Australia', 'Antartika', 'Afrika'],
        'answer': 'Australia',
      },
      {
        'question': 'Kota tertinggi di Indonesia (berdasarkan ketinggian) umumnya berada di pulau?',
        'options': ['Jawa', 'Sumatra', 'Bali', 'Papua'],
        'answer': 'Jawa',
      },
      {
        'question': 'Garis khatulistiwa melewati negara berikut, kecuali?',
        'options': ['Ekuador', 'Indonesia', 'Brasil', 'Kanada'],
        'answer': 'Kanada',
      },
      {
        'question': 'Samudra terbesar di dunia adalah?',
        'options': ['Samudra Atlantik', 'Samudra Hindia', 'Samudra Pasifik', 'Samudra Arktik'],
        'answer': 'Samudra Pasifik',
      },
      {
        'question': 'Istilah "delta" pada geografi merujuk ke?',
        'options': ['Pegunungan', 'Delta sungai (muara berbentuk kipas)', 'Gurun', 'Pulau kecil'],
        'answer': 'Delta sungai (muara berbentuk kipas)',
      },
      {
        'question': 'Jenis batuan yang terbentuk dari magma yang mendingin disebut?',
        'options': ['Batuan sedimen', 'Batuan beku', 'Batuan metamorf', 'Batuan organik'],
        'answer': 'Batuan beku',
      },
      {
        'question': 'Kontinen Asia memiliki negara paling banyak, termasuk negara besar seperti?',
        'options': ['Brasil', 'India', 'Mesir', 'Peru'],
        'answer': 'India',
      },
      {
        'question': 'Kawasan ring of fire terkenal karena aktivitasnya berupa?',
        'options': ['Gurun luas', 'Gunung api dan gempa', 'Hutan hujan lebat', 'Lembah kering'],
        'answer': 'Gunung api dan gempa',
      },
      {
        'question': 'Apa istilah untuk pergerakan lempeng bumi?',
        'options': ['Erosi', 'Tektonik lempeng', 'Sedimentasi', 'Transportasi'],
        'answer': 'Tektonik lempeng',
      },
      {
        'question': 'Satuan yang umum dipakai untuk mengukur jarak bumi-bulan adalah?',
        'options': ['Kilometer', 'Mile', 'Satuan astronomi (AU)', 'Meter'],
        'answer': 'Kilometer',
      },
      {
        'question': 'Kepulauan Indonesia termasuk dalam wilayah biogeografi?',
        'options': ['Neotropis', 'Australasia', 'Indo-Malaya', 'Afrotropika'],
        'answer': 'Indo-Malaya',
      },
    ],
    'Sejarah': [
      {
        'question': 'Kapan Indonesia merdeka?',
        'options': ['1940', '1945', '1950', '1965'],
        'answer': '1945',
      },
      {
        'question': 'Siapa proklamator kemerdekaan Indonesia?',
        'options': [
          'Soekarno dan Hatta',
          'Soedirman dan Suharto',
          'Diponegoro dan Hatta',
          'Kartini dan Cut Nyak Dien'
        ],
        'answer': 'Soekarno dan Hatta',
      },
      {
        'question': 'Di mana teks proklamasi dibacakan?',
        'options': [
          'Istana Negara',
          'Pegangsaan Timur 56',
          'Lapangan Banteng',
          'Gedung Merdeka'
        ],
        'answer': 'Pegangsaan Timur 56',
      },
      {
        'question': 'Siapa presiden Indonesia pertama?',
        'options': ['Soekarno', 'Suharto', 'Habibie', 'Megawati'],
        'answer': 'Soekarno',
      },
      {
        'question': 'Perang Dunia II berakhir tahun?',
        'options': ['1942', '1945', '1947', '1950'],
        'answer': '1945',
      },
      {
        'question': 'Organisasi pemuda yang terkenal dengan Sumpah Pemuda terjadi pada tahun?',
        'options': ['1926', '1928', '1930', '1918'],
        'answer': '1928',
      },
      {
        'question': 'Kerajaan Majapahit berpusat di pulau?',
        'options': ['Sumatra', 'Jawa', 'Bali', 'Sulawesi'],
        'answer': 'Jawa',
      },
      {
        'question': 'Siapa pahlawan nasional yang memimpin Perang Diponegoro?',
        'options': ['Diponegoro', 'Sudirman', 'Gatot Subroto', 'Sisingamangaraja'],
        'answer': 'Diponegoro',
      },
      {
        'question': 'Revolusi Industri pertama kali dimulai di negara?',
        'options': ['Amerika Serikat', 'Inggris', 'Prancis', 'Jerman'],
        'answer': 'Inggris',
      },
      {
        'question': 'Perjanjian yang membagi dunia antara Spanyol dan Portugal pada tahun 1494 dikenal sebagai?',
        'options': ['Perjanjian Versailles', 'Perjanjian Tordesillas', 'Perjanjian Geneva', 'Perjanjian Paris'],
        'answer': 'Perjanjian Tordesillas',
      },
      {
        'question': 'Zaman prasejarah biasanya ditandai oleh penggunaan?',
        'options': ['Besi', 'Perunggu', 'Batu', 'Plastik'],
        'answer': 'Batu',
      },
      {
        'question': 'Sistem tulisan kuno Mesir disebut?',
        'options': ['Kuno Cina', 'Cuneiform', 'Hieroglif', 'Latin'],
        'answer': 'Hieroglif',
      },
      {
        'question': 'Siapa penjelajah yang pertama kali berlayar mengelilingi dunia?',
        'options': ['Christopher Columbus', 'Ferdinand Magellan', 'Vasco da Gama', 'James Cook'],
        'answer': 'Ferdinand Magellan',
      },
      {
        'question': 'Peristiwa Holocaust terjadi pada perang dunia ke-?',
        'options': ['I', 'II', 'III', 'Tidak ada'],
        'answer': 'II',
      },
      {
        'question': 'Pemimpin Proklamasi Indonesia menghadap pada peristiwa penting bersama siapa?',
        'options': ['Soeharto', 'Hatta', 'Sukarno', 'Sukarno-Hatta'],
        'answer': 'Hatta',
      },
      {
        'question': 'Zaman keemasan Islam di Spanyol terkenal dengan pusat kebudayaan di kota?',
        'options': ['Cordoba', 'Madrid', 'Barcelona', 'Seville'],
        'answer': 'Cordoba',
      },
      {
        'question': 'Perang Dingin adalah konflik ideologi antara?',
        'options': ['Jepang dan China', 'AS dan Uni Soviet', 'Prancis dan Inggris', 'India dan Pakistan'],
        'answer': 'AS dan Uni Soviet',
      },
      {
        'question': 'Pembangunan jalur sutra menghubungkan perdagangan antara Asia dan?',
        'options': ['Afrika', 'Eropa', 'Oseania', 'Amerika'],
        'answer': 'Eropa',
      },
      {
        'question': 'Siapa tokoh yang dikenal memproklamasikan paham komunisme bersama Marx?',
        'options': ['Lenin', 'Engels', 'Trotsky', 'Stalin'],
        'answer': 'Engels',
      },
      {
        'question': 'Salah satu penyebab runtuhnya Kekaisaran Romawi Barat adalah?',
        'options': ['Invasi Barbar', 'Letusan Gunung Merapi', 'Perang kemerdekaan', 'Perubahan iklim tiba-tiba'],
        'answer': 'Invasi Barbar',
      },
    ],
    'Sains': [
      {
        'question': 'Planet terdekat dengan matahari adalah?',
        'options': ['Venus', 'Bumi', 'Merkurius', 'Mars'],
        'answer': 'Merkurius',
      },
      {
        'question': 'Air membeku pada suhu?',
        'options': ['0°C', '10°C', '50°C', '100°C'],
        'answer': '0°C',
      },
      {
        'question': 'Zat yang diperlukan manusia untuk bernapas adalah?',
        'options': ['Karbon dioksida', 'Oksigen', 'Nitrogen', 'Hidrogen'],
        'answer': 'Oksigen',
      },
      {
        'question': 'Cahaya merambat paling cepat di?',
        'options': ['Air', 'Udara', 'Vakum', 'Kaca'],
        'answer': 'Vakum',
      },
      {
        'question': 'Bagian tumbuhan tempat fotosintesis terjadi?',
        'options': ['Akar', 'Batang', 'Daun', 'Bunga'],
        'answer': 'Daun',
      },
      {
        'question': 'Unit dasar penyusun makhluk hidup disebut?',
        'options': ['Organ', 'Jaringan', 'Sel', 'Sistem'],
        'answer': 'Sel',
      },
      {
        'question': 'Gaya gravitasi pada permukaan bumi membuat benda memiliki?',
        'options': ['Massa', 'Volume', 'Berat', 'Warna'],
        'answer': 'Berat',
      },
      {
        'question': 'Proses perubahan air menjadi uap disebut?',
        'options': ['Kondensasi', 'Evaporasi (penguapan)', 'Presipitasi', 'Sublimasi'],
        'answer': 'Evaporasi (penguapan)',
      },
      {
        'question': 'Tumbuhan hijau umumnya berwarna hijau karena hadirnya?',
        'options': ['Klorofil', 'Karotenoid', 'Melanin', 'Xantofil'],
        'answer': 'Klorofil',
      },
      {
        'question': 'Satuan SI untuk massa adalah?',
        'options': ['Gram (g)', 'Kilogram (kg)', 'Ton', 'Pound'],
        'answer': 'Kilogram (kg)',
      },
      {
        'question': 'Perubahan wujud dari gas langsung menjadi padat disebut?',
        'options': ['Kondensasi', 'Sublimasi', 'Pembekuan', 'Deposisi'],
        'answer': 'Deposisi',
      },
      {
        'question': 'Apa yang dimaksud dengan fotosintesis?',
        'options': [
          'Proses respirasi pada hewan',
          'Proses produksi makanan oleh tumbuhan menggunakan cahaya',
          'Penguraian bahan organik',
          'Proses pembelahan sel'
        ],
        'answer': 'Proses produksi makanan oleh tumbuhan menggunakan cahaya',
      },
      {
        'question': 'Zat yang merupakan campuran gas utama di udara adalah?',
        'options': ['Oksigen', 'Nitrogen', 'Karbon dioksida', 'Hidrogen'],
        'answer': 'Nitrogen',
      },
      {
        'question': 'Suhu pada skala Celsius untuk titik didih air (pada tekanan 1 atm) adalah?',
        'options': ['0°C', '50°C', '100°C', '212°C'],
        'answer': '100°C',
      },
      {
        'question': 'Contoh perubahan kimia adalah?',
        'options': ['Pembekuan air', 'Pembakaran kayu', 'Pecahnya kaca', 'Penguapan bensin'],
        'answer': 'Pembakaran kayu',
      },
      {
        'question': 'Elektron memiliki muatan?',
        'options': ['Positif', 'Negatif', 'Netral', 'Bervariasi'],
        'answer': 'Negatif',
      },
      {
        'question': 'Alat yang digunakan mengamati benda sangat kecil seperti sel disebut?',
        'options': ['Mikroskop', 'Teleskop', 'Spektrometer', 'Thermometer'],
        'answer': 'Mikroskop',
      },
      {
        'question': 'Energi yang dihasilkan tumbuhan dari fotosintesis utama berupa?',
        'options': ['ATP', 'Glukosa', 'Protein', 'Lemak'],
        'answer': 'Glukosa',
      },
      {
        'question': 'Benda bergerak yang kecepatannya tetap memiliki percepatan sebesar?',
        'options': ['Positif', 'Negatif', 'Nol', 'Tak terdefinisi'],
        'answer': 'Nol',
      },
      {
        'question': 'Bagian bumi yang paling dalam disebut?',
        'options': ['Kerak (crust)', 'Mantel', 'Inti luar', 'Inti dalam'],
        'answer': 'Inti dalam',
      },
    ],
    'Teknologi': [
      {
        'question': 'Siapa penemu telepon?',
        'options': [
          'Thomas Alva Edison',
          'Alexander Graham Bell',
          'Nikola Tesla',
          'Albert Einstein'
        ],
        'answer': 'Alexander Graham Bell',
      },
      {
        'question': 'Bahasa pemrograman yang dibuat oleh Guido van Rossum?',
        'options': ['C++', 'Python', 'Java', 'PHP'],
        'answer': 'Python',
      },
      {
        'question': 'CPU adalah singkatan dari?',
        'options': [
          'Central Processing Unit',
          'Central Power Unit',
          'Control Processing Unit',
          'Central Program Utility'
        ],
        'answer': 'Central Processing Unit',
      },
      {
        'question': 'Teknologi jaringan 5G memiliki kecepatan lebih tinggi dari?',
        'options': ['3G', '4G', '2G', 'WiFi'],
        'answer': '4G',
      },
      {
        'question': 'SSD digunakan untuk?',
        'options': [
          'Meningkatkan grafik',
          'Menyimpan data',
          'Memperkuat sinyal',
          'Menjalankan sistem operasi'
        ],
        'answer': 'Menyimpan data',
      },
      {
        'question': 'Singkatan HTML adalah?',
        'options': [
          'HyperText Markup Language',
          'HighText Machine Language',
          'Hyperlink Markup Language',
          'HyperText Markdown Language'
        ],
        'answer': 'HyperText Markup Language',
      },
      {
        'question': 'Sistem operasi buatan Apple untuk iPhone disebut?',
        'options': ['Android', 'iOS', 'Windows Phone', 'Symbian'],
        'answer': 'iOS',
      },
      {
        'question': 'Perangkat yang menghubungkan jaringan disebut?',
        'options': ['Switch/Router', 'Monitor', 'Printer', 'Keyboard'],
        'answer': 'Switch/Router',
      },
      {
        'question': 'Cloud computing adalah layanan yang menyediakan?',
        'options': [
          'Penyimpanan dan komputasi melalui internet',
          'Perangkat keras saja',
          'Layanan listrik',
          'Akses TV kabel'
        ],
        'answer': 'Penyimpanan dan komputasi melalui internet',
      },
      {
        'question': 'Istilah "AI" kependekan dari?',
        'options': ['Automatic Input', 'Artificial Intelligence', 'Advanced Internet', 'Analog Interface'],
        'answer': 'Artificial Intelligence',
      },
      {
        'question': 'Bahasa yang sering digunakan untuk pengembangan aplikasi Android adalah?',
        'options': ['Swift', 'Kotlin', 'Ruby', 'PHP'],
        'answer': 'Kotlin',
      },
      {
        'question': 'Model penyimpanan data yang menggunakan blok disebut?',
        'options': ['File system', 'Block storage', 'Object storage', 'Relational storage'],
        'answer': 'Block storage',
      },
      {
        'question': 'Perangkat lunak yang membantu menjalankan komputer disebut?',
        'options': ['Aplikasi', 'Sistem operasi', 'Driver', 'Firmware'],
        'answer': 'Sistem operasi',
      },
      {
        'question': 'Protocol dasar untuk web adalah?',
        'options': ['FTP', 'HTTP', 'SMTP', 'SSH'],
        'answer': 'HTTP',
      },
      {
        'question': 'Apa kepanjangan dari "USB"?',
        'options': ['Universal Serial Bus', 'Universal System Bus', 'Unique Serial Bus', 'Unified Serial Bus'],
        'answer': 'Universal Serial Bus',
      },
      {
        'question': 'Apa fungsi firewall pada jaringan?',
        'options': ['Mempercepat internet', 'Mengatur lalu lintas jaringan dan keamanan', 'Menyimpan data', 'Menghapus virus'],
        'answer': 'Mengatur lalu lintas jaringan dan keamanan',
      },
      {
        'question': 'Salah satu bahasa query untuk database relasional adalah?',
        'options': ['JSON', 'SQL', 'HTML', 'CSS'],
        'answer': 'SQL',
      },
      {
        'question': 'Teknologi yang memungkinkan perlindungan identitas digital dengan kunci publik dinamakan?',
        'options': ['Cryptography', 'Compression', 'Streaming', 'Caching'],
        'answer': 'Cryptography',
      },
      {
        'question': 'Perangkat yang mengubah sinyal digital menjadi analog disebut?',
        'options': ['Modem', 'Router', 'Switch', 'Hub'],
        'answer': 'Modem',
      },
      {
        'question': 'Istilah "HTTPs" menunjukkan koneksi yang?',
        'options': ['Tidak terenkripsi', 'Terenkripsi', 'Lebih lambat', 'Tidak stabil'],
        'answer': 'Terenkripsi',
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
    if (widget.isTimed) _startTimer();
  }

  void _startTimer() {
    _remainingSeconds = widget.timeLimit * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _finishQuiz();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _prepareQuestions() {
    if (widget.category == 'Umum') {
      _questions = [];
      _allQuestions.forEach((key, value) {
        _questions.addAll(value);
      });
      _questions.shuffle();
    } else {
      _questions = List.from(_allQuestions[widget.category] ?? []);
    }

    if (_questions.isEmpty) {
      _questions = [
        {
          'question': 'Belum ada soal di kategori ini.',
          'options': ['-', '-', '-', '-'],
          'answer': '-',
        }
      ];
    } else if (_questions.length > widget.totalQuestions) {
      _questions = _questions.sublist(0, widget.totalQuestions);
    }
  }

  void _finishQuiz() {
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

  void _answerQuestion(String selected) {
    setState(() => _selectedAnswer = selected);
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
      _finishQuiz();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subText = isDark ? Colors.grey[400] : Colors.grey[700];
    final cardColor = isDark ? const Color(0xFF1A1F26) : Colors.grey[100];
    final bgColor = isDark ? const Color(0xFF0F1419) : Colors.white;
    final progress = (_currentIndex + 1) / _questions.length;

    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hai, ${widget.userName} 👋',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor)),
                      Text(
                        'Pertanyaan ${_currentIndex + 1} dari ${_questions.length}',
                        style: TextStyle(fontSize: 14, color: subText),
                      ),
                    ],
                  ),
                  if (widget.isTimed)
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
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
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.category,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        question['question'],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor),
                      ),
                      const SizedBox(height: 24),
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
                                        width: 2),
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
                          side: BorderSide(color: textColor.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  if (_currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _selectedAnswer == null ? null : _nextQuestion,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(_currentIndex == _questions.length - 1
                          ? 'Selesai'
                          : 'Selanjutnya'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
