import 'package:flutter/material.dart';
// import 'game.dart';
import 'package:google_fonts/google_fonts.dart';

class Level1LessonPage extends StatefulWidget {
  const Level1LessonPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Level1LessonPageState createState() => _Level1LessonPageState();
}

class _Level1LessonPageState extends State<Level1LessonPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAnswers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Row(
          children: [
            const Icon(Icons.rocket, color: Colors.white),
            // const Icon(Icons.rocket_launch_sharp, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'DASH - Level 1',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildStartGameButtonShort(),
              const SizedBox(height: 20),
              _buildMissionOverview(),
              const SizedBox(height: 20),
              _buildLearningObjectives(),
              const SizedBox(height: 20),
              _buildKeyConcepts(),
              const SizedBox(height: 20),
              _buildOperations(),
              const SizedBox(height: 20),
              _buildCombiningTerms(),
              const SizedBox(height: 20),
              _buildEvaluatingExpressions(),
              const SizedBox(height: 20),
              _buildPracticeProblems(),
              const SizedBox(height: 20),
              _buildGameConnection(),
              const SizedBox(height: 30),
              _buildStartGameButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5ACD), Color(0xFF9370DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(Icons.functions, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Basic Operations with Variables',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Master the fundamentals of algebraic expressions and operations',
              // textAlign: TextAlign.center,
              style: GoogleFonts.rajdhani(
                color: Colors.white70,
                fontSize: 16,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionOverview() {
    return _buildSection(
      icon: Icons.rocket_launch,
      title: 'Mission Overview 🚀',
      content: [
        'Welcome, Astronaut!',
        'In this level, you\'ll learn to work with variables - the building blocks of algebra.',
        'Think of variables as mystery rockets that can carry different values!',
      ],
    );
  }

  Widget _buildLearningObjectives() {
    return _buildSection(
      icon: Icons.school,
      title: 'What You\'ll Learn 📚',
      content: [
        '• What variables are and how to use them',
        '• Adding and subtracting with variables',
        '• Multiplying and dividing with variables',
        '• Combining like terms',
        '• Evaluating expressions',
      ],
    );
  }

  Widget _buildKeyConcepts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🔑 Key Concepts'),
        const SizedBox(height: 15),
        _buildConceptCard(
          'What is a Variable?',
          'A variable is a letter that represents an unknown number. Common variables include x, y, z, a, b, c, n, t.',
          'Think of it like this: If you have 5 rockets and someone gives you x more rockets, you now have (5 + x) rockets!',
          Colors.blue,
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Like Terms vs. Unlike Terms',
          'Like Terms: Same variable, same power\n• 3x and 7x ✓\n• 2y and -5y ✓\n• 4 and 9 ✓ (constants)',
          'Unlike Terms: Different variables or powers\n• 3x and 4y ✗\n• x and x² ✗',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildOperations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🧮 Operations with Variables'),
        const SizedBox(height: 15),
        _buildOperationCard(
          'Addition & Subtraction',
          'Rule: Only combine like terms!',
          [
            '3x + 5x = 8x',
            '7y - 2y = 5y',
            '4x + 3y = 4x + 3y (cannot simplify)',
          ],
          Colors.orange,
        ),
        const SizedBox(height: 10),
        _buildOperationCard(
          'Multiplication',
          'Multiply coefficients and variables separately',
          ['5 × n = 5n', 'x × y = xy', '2a × 3b = 6ab'],
          Colors.purple,
        ),
        const SizedBox(height: 10),
        _buildOperationCard(
          'Division',
          'Divide coefficients and variables separately',
          ['12y ÷ 4 = 3y', '15ab ÷ 5a = 3b', 'x² ÷ x = x'],
          Colors.teal,
        ),
      ],
    );
  }

  Widget _buildCombiningTerms() {
    return _buildSection(
      icon: Icons.merge_type,
      title: 'Combining Like Terms 🎯',
      content: [
        'Step-by-step process:',
        '1. Identify like terms (same variable, same power)',
        '2. Add or subtract their coefficients',
        '3. Keep the variable part the same',
        '',
        'Example: Simplify 5x + 3y - 2x + 7y',
        '1. Group like terms: (5x - 2x) + (3y + 7y)',
        '2. Combine: 3x + 10y',
      ],
    );
  }

  Widget _buildEvaluatingExpressions() {
    return _buildSection(
      icon: Icons.calculate,
      title: 'Evaluating Expressions 🔢',
      content: [
        'Substitution: Replace variables with given numbers',
        '',
        'Example: Evaluate 3x + 2y when x = 4 and y = 5',
        '1. Substitute: 3(4) + 2(5)',
        '2. Calculate: 12 + 10 = 22',
      ],
    );
  }

  Widget _buildPracticeProblems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🏆 Practice Problems'),
        const SizedBox(height: 15),
        _buildPracticeCard(
          'Warm-up',
          [
            '1. Combine: 7a + 3a = ?',
            '2. Simplify: 5x - 2x + 4 = ?',
            '3. Evaluate 2n + 1 when n = 6',
          ],
          ['1) 10a', '2) 3x + 4', '3) 13'],
          Colors.blue,
        ),
        const SizedBox(height: 10),
        _buildPracticeCard(
          'Challenge',
          [
            '1. Simplify: 4x + 3y - x + 2y + 5',
            '2. Evaluate: 3a²b when a = 2 and b = 3',
            '3. Combine: 8m - 3n + 2m - 7n',
          ],
          ['1) 3x + 5y + 5', '2) 36', '3) 10m - 10n'],
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildGameConnection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF45a049)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.games, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Game Connection 🎮',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'In the upcoming game level, you\'ll navigate your rocket through space by solving problems with:',
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 16,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          ...[
            '• Fuel calculations (addition/subtraction)',
            '• Speed adjustments (multiplication/division)',
            '• Resource management (combining like terms)',
            '• Mission parameters (evaluating expressions)',
          ].map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                item,
                style: GoogleFonts.rajdhani(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Each correct answer propels your rocket forward. Wrong answers create obstacles you\'ll need to overcome!',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartGameButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            // navigate to game level
            Navigator.pushNamed(context, '/game');
            /*
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const GameScreen(level: 1), // Pass the level here
            ));
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: Colors.black54,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                'START MISSION',
                style: GoogleFonts.abrilFatface(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 12),
              const Text('🚀', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartGameButtonShort() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 36,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to game level
            Navigator.pushNamed(context, '/game');
            /*
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const GameScreen(level: 1), // Pass the level here
            ));
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B6B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: Colors.black54,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow, color: Colors.white, size: 27),
              const SizedBox(width: 10),
              Text(
                'START MISSION',
                style: GoogleFonts.abrilFatface(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 12),
              const Text('☄️', style: TextStyle(fontSize: 20)), // 🧮
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<String> content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A4A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A6A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...content.map(
            (text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                text,
                style: GoogleFonts.rajdhani(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.orbitron(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildConceptCard(
    String title,
    String description,
    String example,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A4A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.exo2(
              color: accentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.rajdhani(
              color: Colors.white70,
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              example,
              style: GoogleFonts.rajdhani(
                color: Colors.white,
                fontSize: 13,
                fontStyle: FontStyle.italic,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationCard(
    String title,
    String rule,
    List<String> examples,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A4A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.exo2(
              color: accentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            rule,
            style: GoogleFonts.rajdhani(
              color: Colors.white70,
              fontSize: 13,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          ...examples.map(
            (example) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                '• $example',
                style: GoogleFonts.rajdhani(
                  color: Colors.white60,
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(
    String level,
    List<String> problems,
    List<String> answers,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A4A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                level,
                style: GoogleFonts.exo2(
                  color: accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showAnswers = !_showAnswers;
                  });
                },
                child: Text(
                  _showAnswers ? 'Hide Answers' : 'Show Answers',
                  style: GoogleFonts.rajdhani(
                    color: accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...problems.map(
            (problem) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                problem,
                style: GoogleFonts.rajdhani(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ),
          ),
          if (_showAnswers) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Answers:',
                    style: GoogleFonts.exo2(
                      color: accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...answers.map(
                    (answer) => Text(
                      answer,
                      style: GoogleFonts.rajdhani(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
