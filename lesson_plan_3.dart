import 'package:flutter/material.dart';
// import 'game.dart';
import 'package:google_fonts/google_fonts.dart';

class Level3LessonPage extends StatefulWidget {
  const Level3LessonPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Level3LessonPageState createState() => _Level3LessonPageState();
}

class _Level3LessonPageState extends State<Level3LessonPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAnswers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F3A),
        title: Row(
          children: [
            const Icon(Icons.rocket, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'DASH - Level 3',
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
              Color(0xFF0B0E1A), // Deep space blue
              Color(0xFF1A1F3A), // Midnight blue
              Color(0xFF2D1B69), // Deep purple
              Color(0xFF0B0E1A), // Back to deep space
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
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
              _buildLinearEquationBasics(),
              const SizedBox(height: 20),
              _buildSlopeFormulas(),
              const SizedBox(height: 20),
              _buildSlopeTypes(),
              const SizedBox(height: 20),
              _buildLinearEquationForms(),
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
          colors: [Color(0xFF4A90E2), Color(0xFF7B68EE), Color(0xFF9A4AE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Linear Equations & Slope',
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
              'Master the trajectory paths of linear functions and slope calculations',
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
        'Welcome to Advanced Navigation, Space Commander!',
        'This level teaches you to understand linear equations - the mathematical blueprints for straight-line trajectories.',
        'Master slope calculations to plot perfect flight paths through the cosmos!',
      ],
    );
  }

  Widget _buildLearningObjectives() {
    return _buildSection(
      icon: Icons.school,
      title: 'What You\'ll Learn 📚',
      content: [
        '• Understanding linear equations and their properties',
        '• Calculating slope between two points',
        '• Identifying different types of slopes (positive, negative, zero, undefined)',
        '• Working with slope-intercept, point-slope, and standard forms',
        '• Interpreting slope in real-world contexts',
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
          'What is a Linear Equation?',
          'A linear equation creates a straight line when graphed, representing a constant rate of change.',
          'Example: y = 2x + 3\nThis means for every 1 unit right, go 2 units up!\nPerfect for plotting spacecraft trajectories.',
          const Color(0xFF4FC3F7),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Understanding Slope',
          'Slope measures the steepness of a line - how much it rises over how much it runs.',
          'Think of slope as rocket thrust angle:\nSteep slope = rapid altitude gain\nGentle slope = gradual climb\nNegative slope = descent trajectory',
          const Color(0xFF66BB6A),
        ),
      ],
    );
  }

  Widget _buildLinearEquationBasics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('📐 Linear Equation Basics'),
        const SizedBox(height: 15),
        _buildOperationCard(
          'Properties of Linear Equations',
          'Key characteristics that define linear functions:',
          [
            'Degree of 1 (highest power is x¹)',
            'Graph forms a straight line',
            'Constant rate of change (slope)',
            'Can have at most one x-intercept and one y-intercept',
          ],
          const Color(0xFFFF7043),
        ),
        const SizedBox(height: 10),
        _buildOperationCard(
          'Variables in Linear Equations',
          'Understanding the components:',
          [
            'x = independent variable (input/time)',
            'y = dependent variable (output/position)',
            'm = slope (rate of change)',
            'b = y-intercept (starting point)',
          ],
          const Color(0xFFAB47BC),
        ),
      ],
    );
  }

  Widget _buildSlopeFormulas() {
    return _buildSection(
      icon: Icons.functions,
      title: 'Slope Calculation 📊',
      content: [
        'The slope formula between two points:',
        '',
        'Slope (m) = (y₂ - y₁) / (x₂ - x₁)',
        '',
        'Step-by-step process:',
        '1. Identify two points: (x₁, y₁) and (x₂, y₂)',
        '2. Find the change in y: y₂ - y₁ (rise)',
        '3. Find the change in x: x₂ - x₁ (run)',
        '4. Divide rise by run: m = rise/run',
        '',
        'Example: Points (2, 3) and (6, 11)',
        'Slope = (11 - 3) / (6 - 2) = 8/4 = 2',
        'The line rises 2 units for every 1 unit right!',
      ],
    );
  }

  Widget _buildSlopeTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('📈 Types of Slope'),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Positive Slope',
          'Line goes up from left to right. As x increases, y increases.',
          'Example: m = 3/2 = 1.5\nSpacecraft ascending at steady rate\nUp 3 units for every 2 units right',
          const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Negative Slope',
          'Line goes down from left to right. As x increases, y decreases.',
          'Example: m = -2/3\nSpacecraft descending trajectory\nDown 2 units for every 3 units right',
          const Color(0xFFEF5350),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Zero Slope',
          'Horizontal line. No change in y as x changes.',
          'Example: m = 0, equation y = 5\nSpacecraft maintaining constant altitude\nCruising at steady height',
          const Color(0xFFFFCA28),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Undefined Slope',
          'Vertical line. Division by zero (no change in x).',
          'Example: x = 3 (vertical line)\nLaunch sequence - straight up!\nInfinite steepness',
          const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildLinearEquationForms() {
    return _buildSection(
      icon: Icons.science,
      title: 'Linear Equation Forms 🔬',
      content: [
        'Three main forms for linear equations:',
        '',
        '1. Slope-Intercept Form: y = mx + b',
        '   • m = slope, b = y-intercept',
        '   • Easy to identify slope and starting point',
        '   • Example: y = -2x + 7',
        '',
        '2. Point-Slope Form: y - y₁ = m(x - x₁)',
        '   • m = slope, (x₁, y₁) = known point',
        '   • Useful when you know slope and one point',
        '   • Example: y - 3 = 2(x - 1)',
        '',
        '3. Standard Form: Ax + By = C',
        '   • A, B, C are integers, A ≥ 0',
        '   • Easy to find intercepts',
        '   • Example: 3x + 2y = 12',
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
          'Slope Calculation',
          [
            '1. Find slope between (1, 2) and (5, 10)',
            '2. Find slope between (-3, 7) and (2, -3)',
            '3. Find slope between (4, 6) and (4, -2)',
          ],
          ['1) m = 2', '2) m = -2', '3) m = undefined'],
          const Color(0xFF42A5F5),
        ),
        const SizedBox(height: 10),
        _buildPracticeCard(
          'Linear Equations',
          [
            '1. Write y = 3x - 4 in standard form',
            '2. Find slope and y-intercept of y = -½x + 6',
            '3. Write equation with slope 2 through (3, 1)',
          ],
          ['1) 3x - y = 4', '2) m = -½, b = 6', '3) y = 2x - 5'],
          const Color(0xFFE57373),
        ),
      ],
    );
  }

  Widget _buildGameConnection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF29B6F6), Color(0xFF7C4DFF), Color(0xFFE91E63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 2,
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
            'In this advanced mission, you\'ll use linear equations and slope to:',
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 16,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          ...[
            '• Calculate optimal flight trajectories (slope calculations)',
            '• Plot intercept courses with space stations (y-intercepts)',
            '• Navigate through linear asteroid fields (equation forms)',
            '• Match spacecraft velocity profiles (rate of change)',
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
            'Each linear equation you master unlocks precise navigation controls. Plot your course through the mathematical cosmos!',
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
            // Navigator.pushNamed(context, '/level3_game');
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const GameScreen(level: 3), // Pass the level here
              ),
            );
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C4DFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: const Color(0xFF7C4DFF).withValues(alpha: 0.5),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C4DFF), Color(0xFF536DFE)],
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
            // Navigator.pushNamed(context, '/level3_game');
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const GameScreen(level: 3), // Pass the level here
              ),
            );
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C4DFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: const Color(0xFF7C4DFF).withValues(alpha: 0.5),
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
              const Text('〰️', style: TextStyle(fontSize: 20)),
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
            const Color(0xFF1E2A78).withValues(alpha: 0.8),
            const Color(0xFF2D1B69).withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E2A78).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
            const Color(0xFF1E2A78).withValues(alpha: 0.7),
            const Color(0xFF2D1B69).withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 2),
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
            const Color(0xFF1E2A78).withValues(alpha: 0.7),
            const Color(0xFF2D1B69).withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 6,
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
            const Color(0xFF1E2A78).withValues(alpha: 0.7),
            const Color(0xFF2D1B69).withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.1),
            blurRadius: 6,
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
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.3),
                  width: 1,
                ),
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
