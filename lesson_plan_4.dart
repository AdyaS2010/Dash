import 'package:flutter/material.dart';
// import 'game.dart';
import 'package:google_fonts/google_fonts.dart';

class Level4LessonPage extends StatefulWidget {
  const Level4LessonPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Level4LessonPageState createState() => _Level4LessonPageState();
}

class _Level4LessonPageState extends State<Level4LessonPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAnswers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A0F1F),
        title: Row(
          children: [
            const Icon(Icons.rocket, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'DASH - Level 4',
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
            colors: [
              Color(0xFF0A0A0A), // Deep black
              Color(0xFF1A0F1F), // Dark purple
              Color(0xFF2D1537), // Rich purple
              Color(0xFF4A1A5C), // Vibrant purple
              Color(0xFF1A0F1F), // Back to dark purple
              Color(0xFF0A0A0A), // Deep black
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
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
              _buildExponentialBasics(),
              const SizedBox(height: 20),
              _buildExponentRules(),
              const SizedBox(height: 20),
              _buildRadicalBasics(),
              const SizedBox(height: 20),
              _buildRadicalOperations(),
              const SizedBox(height: 20),
              _buildSimplificationStrategies(),
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
          colors: [Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF673AB7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Exponential & Radical Expressions',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Harness the power of exponential growth and radical simplification in deep space',
              style: GoogleFonts.rajdhani(
                color: Colors.white70,
                fontSize: 16,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionOverview() {
    return _buildSection(
      icon: Icons.explore,
      title: 'Mission Overview 🌌',
      content: [
        'Welcome to Power Systems Control, Space Engineer!',
        'This advanced level explores exponential and radical expressions - the mathematical engines that power interstellar travel.',
        'Master these cosmic calculations to unlock hyperdrive capabilities and quantum field manipulations!',
      ],
    );
  }

  Widget _buildLearningObjectives() {
    return _buildSection(
      icon: Icons.school,
      title: 'What You\'ll Master 🎯',
      content: [
        '• Simplifying exponential expressions using power rules',
        '• Understanding and applying laws of exponents',
        '• Working with radical expressions and nth roots',
        '• Rationalizing denominators and complex radicals',
        '• Converting between exponential and radical forms',
        '• Solving real-world applications involving exponential growth',
      ],
    );
  }

  Widget _buildKeyConcepts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('⚡ Core Power Systems'),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Exponential Expressions',
          'Powers that represent repeated multiplication, essential for calculating energy outputs.',
          'Example: 2⁴ = 2 × 2 × 2 × 2 = 16\nReactor power levels increase exponentially!\nBase = energy source, Exponent = amplification factor',
          const Color(0xFFFF5722),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Radical Expressions',
          'Root operations that find the base value from a given power - reverse engineering energy systems.',
          'Example: ∛125 = 5 (since 5³ = 125)\nFinding optimal fuel ratios from total energy output\nRadicals unlock the secrets of exponential systems',
          const Color(0xFFFF9800),
        ),
      ],
    );
  }

  Widget _buildExponentialBasics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🚀 Exponential Fundamentals'),
        const SizedBox(height: 15),
        _buildOperationCard(
          'Anatomy of Exponential Expressions',
          'Understanding the components of power systems:',
          [
            'Base (b): The foundation value being multiplied',
            'Exponent (n): How many times to multiply the base',
            'Power: The complete expression bⁿ',
            'Special cases: b⁰ = 1, b¹ = b, b⁻ⁿ = 1/bⁿ',
          ],
          const Color(0xFFE91E63),
        ),
        const SizedBox(height: 10),
        _buildOperationCard(
          'Zero and Negative Exponents',
          'Critical power system behaviors:',
          [
            'Any base to power 0 equals 1: x⁰ = 1 (system reset)',
            'Negative exponents create reciprocals: x⁻³ = 1/x³',
            'Move negative exponents by flipping fraction',
            'Essential for energy conservation calculations',
          ],
          const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildExponentRules() {
    return _buildSection(
      icon: Icons.settings,
      title: 'Laws of Exponents ⚙️',
      content: [
        'The fundamental rules governing power systems:',
        '',
        '1. Product Rule: bᵐ × bⁿ = bᵐ⁺ⁿ',
        '   Example: 2³ × 2² = 2⁵ = 32',
        '   (Combining power sources adds their exponents)',
        '',
        '2. Quotient Rule: bᵐ ÷ bⁿ = bᵐ⁻ⁿ',
        '   Example: x⁷ ÷ x³ = x⁴',
        '   (Dividing power reduces exponents)',
        '',
        '3. Power Rule: (bᵐ)ⁿ = bᵐˣⁿ',
        '   Example: (3²)⁴ = 3⁸',
        '   (Amplifying power multiplies exponents)',
        '',
        '4. Product to Power: (ab)ⁿ = aⁿbⁿ',
        '   Example: (2x)³ = 8x³',
        '   (Distribute power to all components)',
        '',
        '5. Quotient to Power: (a/b)ⁿ = aⁿ/bⁿ',
        '   Example: (x/y)² = x²/y²',
        '   (Power affects numerator and denominator)',
      ],
    );
  }

  Widget _buildRadicalBasics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🔮 Radical Operations'),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Understanding Radicals',
          'Radicals are the inverse operations of exponents - finding the root cause of power.',
          'Square root: √16 = 4 (since 4² = 16)\nCube root: ∛27 = 3 (since 3³ = 27)\nNth root: ⁿ√a = b means bⁿ = a',
          const Color(0xFF607D8B),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Radical Notation',
          'Different ways to express radical operations in your space calculations.',
          'Radical form: ³√x² \nExponential form: x^(2/3)\nIndex = 3, Radicand = x²\nThese forms are interchangeable!',
          const Color(0xFF795548),
        ),
      ],
    );
  }

  Widget _buildRadicalOperations() {
    return _buildSection(
      icon: Icons.calculate,
      title: 'Radical Manipulation 🧮',
      content: [
        'Essential techniques for radical expressions:',
        '',
        '1. Simplifying Radicals:',
        '   • Factor out perfect powers from radicand',
        '   • √50 = √(25 × 2) = 5√2',
        '   • ³√54 = ³√(27 × 2) = 3³√2',
        '',
        '2. Adding/Subtracting Radicals:',
        '   • Only like radicals can be combined',
        '   • 3√5 + 2√5 = 5√5',
        '   • √3 + √5 cannot be simplified further',
        '',
        '3. Multiplying Radicals:',
        '   • √a × √b = √(ab)',
        '   • √6 × √10 = √60 = 2√15',
        '',
        '4. Rationalizing Denominators:',
        '   • Remove radicals from denominators',
        '   • 1/√3 = √3/3 (multiply by √3/√3)',
        '   • Essential for precise calculations',
      ],
    );
  }

  Widget _buildSimplificationStrategies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🎯 Advanced Techniques'),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Exponential Simplification',
          'Strategic approaches to complex exponential expressions.',
          'Factor common bases: 2⁴ × 8² = 2⁴ × (2³)² = 2⁴ × 2⁶ = 2¹⁰\nUse laws systematically\nConvert to same base when possible',
          const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Radical Simplification',
          'Mastering the art of radical reduction for optimal calculations.',
          'Find perfect factors: √72 = √(36 × 2) = 6√2\nRationalize: 1/(2-√3) × (2+√3)/(2+√3) = (2+√3)\nSimplify step by step',
          const Color(0xFF2196F3),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Converting Forms',
          'Seamlessly switch between exponential and radical representations.',
          'Radical to exponential: ⁴√x³ = x^(3/4)\nExponential to radical: x^(2/5) = ⁵√(x²)\nFractional exponents bridge both worlds',
          const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildPracticeProblems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🏆 Training Exercises'),
        const SizedBox(height: 15),
        _buildPracticeCard(
          'Exponent Operations',
          [
            '1. Simplify: (2³)² × 2⁴',
            '2. Simplify: x⁷ × x⁻³ ÷ x²',
            '3. Simplify: (3x²y)³',
          ],
          ['1) 2¹⁰ = 1024', '2) x² ', '3) 27x⁶y³'],
          const Color(0xFFFF5722),
        ),
        const SizedBox(height: 10),
        _buildPracticeCard(
          'Radical Simplification',
          [
            '1. Simplify: √98',
            '2. Rationalize: 1/(√5 - 2)',
            '3. Convert: ³√x⁴ to exponential form',
          ],
          ['1) 7√2', '2) -(√5 + 2)', '3) x^(4/3)'],
          const Color(0xFF607D8B),
        ),
        const SizedBox(height: 10),
        _buildPracticeCard(
          'Mixed Operations',
          [
            '1. Simplify: √50 + 3√8 - √18',
            '2. Evaluate: 8^(2/3)',
            '3. Simplify: (x^(1/2))⁴ × x^(-1)',
          ],
          ['1) 7√2', '2) 4', '3) x'],
          const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  Widget _buildGameConnection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE91E63),
            Color(0xFF9C27B0),
            Color(0xFF673AB7),
            Color(0xFF3F51B5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C27B0).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 6),
            spreadRadius: 3,
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
                'Power Systems Integration 🎮',
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
            'In this quantum-level mission, you\'ll apply exponential and radical mastery to:',
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 16,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          ...[
            '• Calculate hyperdrive power requirements (exponential growth)',
            '• Optimize quantum field generators (radical simplification)',
            '• Balance reactor core energy outputs (exponent rules)',
            '• Decode alien technology specifications (form conversions)',
            '• Navigate through exponential space-time distortions',
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
            'Master these power systems to unlock the deepest secrets of the mathematical universe. Your calculations will determine the fate of entire star systems!',
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
            // Navigator.pushNamed(context, '/level4_game');
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const GameScreen(level: 4), // Pass the level here
              ),
            );
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE91E63),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 10,
            shadowColor: const Color(0xFFE91E63).withValues(alpha: 0.6),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
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
                    fontSize: 16,
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
            // Navigator.pushNamed(context, '/level4_game');
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const GameScreen(level: 4), // Pass the level here
              ),
            );
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE91E63),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: const Color(0xFFE91E63).withValues(alpha: 0.5),
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
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 12),
              const Text('⚡', style: TextStyle(fontSize: 20)),
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
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D1537).withValues(alpha: 0.8),
            const Color(0xFF4A1A5C).withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE91E63).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D1537).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
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
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D1537).withValues(alpha: 0.7),
            const Color(0xFF4A1A5C).withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
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
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
                width: 1,
              ),
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
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D1537).withValues(alpha: 0.7),
            const Color(0xFF4A1A5C).withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2D1537).withValues(alpha: 0.7),
            const Color(0xFF4A1A5C).withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                  _showAnswers ? 'Hide Solutions' : 'Show Solutions',
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
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Solutions:',
                        style: GoogleFonts.exo2(
                          color: accentColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...answers.map(
                    (answer) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        answer,
                        style: GoogleFonts.rajdhani(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
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
