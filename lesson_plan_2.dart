import 'package:flutter/material.dart';
// import 'game.dart';
import 'package:google_fonts/google_fonts.dart';

class Level2LessonPage extends StatefulWidget {
  const Level2LessonPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Level2LessonPageState createState() => _Level2LessonPageState();
}

class _Level2LessonPageState extends State<Level2LessonPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAnswers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D2818),
        title: Row(
          children: [
            const Icon(Icons.rocket, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'DASH - Level 2',
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ // shades of (quite deep) green
              Color(0xFF1A2E1A),
              Color(0xFF0D2818),
              Color(0xFF1B3B1B),
              Color(0xFF0A1F15),
              Color(0xFF144014),
              Color(0xFF0D2818),
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
        /*
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A2E1A), Color(0xFF0D2818), Color(0xFF0A1F15)],
          ),
        ),
        */
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
              _buildInequalitySymbols(),
              const SizedBox(height: 20),
              _buildSolvingInequalities(),
              const SizedBox(height: 20),
              _buildSpecialRules(),
              const SizedBox(height: 20),
              _buildGraphingInequalities(),
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
          colors: [Color(0xFF228B22), Color(0xFF32CD32)],
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
              const Icon(Icons.compare_arrows, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Single-Variable Inequalities',
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
              'Navigate through mathematical ranges and solve inequality problems',
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
        'Welcome back, Space Navigator!',
        'This level challenges you to work with inequalities - mathematical expressions that show ranges of values.',
        'Think of inequalities as navigation coordinates that define safe flight zones for your rocket!',
      ],
    );
  }

  Widget _buildLearningObjectives() {
    return _buildSection(
      icon: Icons.school,
      title: 'What You\'ll Learn 📚',
      content: [
        '• Understanding inequality symbols and their meanings',
        '• Solving single-variable inequalities step by step',
        '• Special rules when multiplying/dividing by negatives',
        '• Graphing inequality solutions on number lines',
        '• Interpreting inequality solutions in real contexts',
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
          'What is an Inequality?',
          'An inequality compares two expressions using symbols like <, >, ≤, or ≥ instead of equals.',
          'Example: x + 3 > 7 means "x plus 3 is greater than 7"\nThis tells us x must be greater than 4 for the rocket to have enough fuel!',
          Colors.blue,
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Solutions vs. Equations',
          'Equations have one solution, but inequalities have ranges of solutions.',
          'Equation: x + 2 = 5 → x = 3 (only one answer)\nInequality: x + 2 > 5 → x > 3 (infinite solutions: 4, 5, 6, 7...)',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildInequalitySymbols() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('📊 Inequality Symbols'),
        const SizedBox(height: 15),
        _buildOperationCard(
          'Basic Symbols',
          'Master these navigation symbols:',
          [
            '< means "less than" (open circle)',
            '> means "greater than" (open circle)',
            '≤ means "less than or equal to" (closed circle)',
            '≥ means "greater than or equal to" (closed circle)',
          ],
          Colors.orange,
        ),
        const SizedBox(height: 10),
        _buildOperationCard(
          'Memory Tricks',
          'Remember the symbols with these space analogies:',
          [
            'The "mouth" always eats the bigger number',
            'Think: Rocket speed < Light speed',
            'Or: Fuel level ≥ Minimum required',
          ],
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSolvingInequalities() {
    return _buildSection(
      icon: Icons.engineering,
      title: 'Solving Inequalities 🔧',
      content: [
        'Basic steps (same as equations):',
        '1. Simplify both sides if needed',
        '2. Get variable terms on one side',
        '3. Get constants on the other side',
        '4. Divide or multiply to isolate the variable',
        '',
        'Example: Solve 2x + 5 < 13',
        '1. Subtract 5: 2x < 8',
        '2. Divide by 2: x < 4',
        'Solution: All numbers less than 4',
      ],
    );
  }

  Widget _buildSpecialRules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('⚠️ Special Rules'),
        const SizedBox(height: 15),
        _buildConceptCard(
          'The Flip Rule',
          'When you multiply or divide both sides by a NEGATIVE number, flip the inequality symbol!',
          'Example: -2x > 6\nDivide by -2: x < -3 (notice the flip!)\nWhy? Because -2(-4) = 8 > 6, but -4 < -3',
          Colors.red,
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'When to Flip',
          'Only flip when multiplying/dividing by negatives. Adding/subtracting never flips!',
          'Safe operations: +5, -3, ×2, ÷4\nFlip required: ×(-2), ÷(-3), multiply by negative variable',
          Colors.amber,
        ),
      ],
    );
  }

  Widget _buildGraphingInequalities() {
    return _buildSection(
      icon: Icons.timeline,
      title: 'Graphing on Number Lines 📈',
      content: [
        'Visual representation of solutions:',
        '',
        'Open Circle (○): Use for < or >',
        '• The number itself is NOT included',
        '• Example: x < 3 uses open circle at 3',
        '',
        'Closed Circle (●): Use for ≤ or ≥',
        '• The number itself IS included',
        '• Example: x ≥ -2 uses closed circle at -2',
        '',
        'Shading: Shade the region where solutions exist',
        '• x < 3: shade left of 3',
        '• x ≥ -2: shade right of -2',
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
          ['1. Solve: x + 7 > 12', '2. Solve: 3x ≤ 15', '3. Solve: x - 4 < 2'],
          ['1) x > 5', '2) x ≤ 5', '3) x < 6'],
          Colors.blue,
        ),
        const SizedBox(height: 10),
        _buildPracticeCard(
          'Challenge',
          [
            '1. Solve: -2x + 3 > 11',
            '2. Solve: 4x - 7 ≤ 2x + 5',
            '3. Solve: -3(x + 2) < 9',
          ],
          ['1) x < -4', '2) x ≤ 6', '3) x > -5'],
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
          colors: [Color(0xFF00CED1), Color(0xFF20B2AA)],
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
            'In this mission, you\'ll navigate through space using inequality solutions:',
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 16,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          ...[
            '• Safe velocity ranges (speed inequalities)',
            '• Fuel efficiency zones (resource inequalities)',
            '• Asteroid field navigation (distance inequalities)',
            '• Mission parameter bounds (constraint solving)',
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
            'Each inequality you solve reveals a safe navigation zone. Wrong solutions lead to dangerous asteroid fields!',
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
            // Navigate to game level
            // Navigator.pushNamed(context, '/level2_game');
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const GameScreen(level: 2), // Pass the level here
              ),
            );
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF32CD32),
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
            // Navigator.pushNamed(context, '/level2_game');
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const GameScreen(level: 2), // Pass the level here
              ),
            );
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF32CD32),
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
              const Text('⚖️', style: TextStyle(fontSize: 20)),
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
        color: const Color(0xFF2A4A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A6A3A), width: 1),
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
        color: const Color(0xFF2A4A2A),
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
        color: const Color(0xFF2A4A2A),
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
        color: const Color(0xFF2A4A2A),
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
