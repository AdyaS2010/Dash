import 'package:flutter/material.dart';
// import 'game.dart';
import 'package:google_fonts/google_fonts.dart';

class Level5LessonPage extends StatefulWidget {
  const Level5LessonPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Level5LessonPageState createState() => _Level5LessonPageState();
}

class _Level5LessonPageState extends State<Level5LessonPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAnswers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D1B4E),
        title: Row(
          children: [
            const Icon(Icons.rocket, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'DASH - Level 5',
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
              Color(0xFF0D0B1E), // Deep cosmic black
              Color(0xFF2D1B4E), // Royal purple
              Color(0xFF8B5CF6), // Bright purple
              Color(0xFFEC4899), // Magenta
              Color(0xFF0D0B1E), // Back to cosmic black
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
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
              _buildQuadraticBasics(),
              const SizedBox(height: 20),
              _buildStandardForm(),
              const SizedBox(height: 20),
              _buildVertexForm(),
              const SizedBox(height: 20),
              _buildFactoredForm(),
              const SizedBox(height: 20),
              _buildParabolaProperties(),
              const SizedBox(height: 20),
              _buildSolvingMethods(),
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
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
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
              const Icon(Icons.auto_graph, color: Colors.white, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Quadratic Equations & Parabolas',
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
              'Navigate curved trajectories and master the geometry of orbital mechanics',
              textAlign: TextAlign.center,
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
      icon: Icons.satellite_alt,
      title: 'Mission Overview 🛰️',
      content: [
        'Welcome to Orbital Mechanics, Space Commander!',
        'This advanced level teaches you to understand quadratic equations - the mathematical foundation for curved trajectories and orbital paths.',
        'Master parabolic functions to calculate satellite orbits, planetary paths, and gravity-assisted maneuvers!',
      ],
    );
  }

  Widget _buildLearningObjectives() {
    return _buildSection(
      icon: Icons.school,
      title: 'What You\'ll Master 🎯',
      content: [
        '• Understanding quadratic functions and their unique properties',
        '• Working with standard, vertex, and factored forms',
        '• Analyzing parabola characteristics (vertex, axis of symmetry, direction)',
        '• Finding roots using factoring, completing the square, and quadratic formula',
        '• Interpreting quadratic models in real-world orbital scenarios',
        '• Graphing parabolas and identifying key features',
      ],
    );
  }

  Widget _buildKeyConcepts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🌟 Key Concepts'),
        const SizedBox(height: 15),
        _buildConceptCard(
          'What is a Quadratic Function?',
          'A quadratic function creates a parabola when graphed, representing acceleration and curved motion.',
          'General form: f(x) = ax² + bx + c\nExample: f(x) = x² - 4x + 3\nPerfect for modeling satellite trajectories and orbital mechanics!',
          const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Understanding Parabolas',
          'Parabolas are U-shaped curves that model projectile motion, orbits, and gravitational fields.',
          'Key features:\n• Vertex: highest/lowest point\n• Axis of symmetry: vertical line through vertex\n• Direction: opens up (a > 0) or down (a < 0)\n• Roots: where parabola crosses x-axis',
          const Color(0xFFEC4899),
        ),
      ],
    );
  }

  Widget _buildQuadraticBasics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🔢 Quadratic Function Basics'),
        const SizedBox(height: 15),
        _buildOperationCard(
          'Quadratic Function Properties',
          'Essential characteristics that define quadratic functions:',
          [
            'Degree of 2 (highest power is x²)',
            'Graph forms a parabola (U-shape)',
            'Has a vertex (maximum or minimum point)',
            'Symmetric about a vertical line',
            'Can have 0, 1, or 2 real roots',
          ],
          const Color(0xFF8B5CF6),
        ),
        const SizedBox(height: 10),
        _buildOperationCard(
          'The Coefficient \'a\' Controls Shape',
          'How the leading coefficient affects the parabola:',
          [
            'a > 0: parabola opens upward (smiling)',
            'a < 0: parabola opens downward (frowning)',
            '|a| > 1: parabola is narrow (steep)',
            '|a| < 1: parabola is wide (gentle)',
          ],
          const Color(0xFF06B6D4),
        ),
      ],
    );
  }

  Widget _buildStandardForm() {
    return _buildSection(
      icon: Icons.straighten,
      title: 'Standard Form 📏',
      content: [
        'Standard Form: f(x) = ax² + bx + c',
        '',
        'Components:',
        '• a: coefficient of x² (controls width and direction)',
        '• b: coefficient of x (affects axis of symmetry)',
        '• c: constant term (y-intercept)',
        '',
        'Example: f(x) = 2x² - 8x + 5',
        '• a = 2 (opens upward, narrow)',
        '• b = -8 (shifts axis of symmetry)',
        '• c = 5 (y-intercept at (0, 5))',
        '',
        'Axis of symmetry: x = -b/(2a)',
        'For our example: x = -(-8)/(2·2) = 8/4 = 2',
      ],
    );
  }

  Widget _buildVertexForm() {
    return _buildSection(
      icon: Icons.place,
      title: 'Vertex Form 📍',
      content: [
        'Vertex Form: f(x) = a(x - h)² + k',
        '',
        'Components:',
        '• a: same as standard form (width and direction)',
        '• (h, k): vertex coordinates',
        '• h: x-coordinate of vertex',
        '• k: y-coordinate of vertex',
        '',
        'Example: f(x) = 2(x - 3)² - 1',
        '• Vertex: (3, -1)',
        '• Opens upward (a = 2 > 0)',
        '• Axis of symmetry: x = 3',
        '',
        'Perfect for orbital calculations where you know the highest or lowest point!',
      ],
    );
  }

  Widget _buildFactoredForm() {
    return _buildSection(
      icon: Icons.scatter_plot,
      title: 'Factored Form 🎯',
      content: [
        'Factored Form: f(x) = a(x - r₁)(x - r₂)',
        '',
        'Components:',
        '• a: same coefficient (width and direction)',
        '• r₁, r₂: roots (x-intercepts)',
        '• Shows where parabola crosses x-axis',
        '',
        'Example: f(x) = 2(x - 1)(x - 5)',
        '• Roots: x = 1 and x = 5',
        '• Parabola crosses x-axis at (1, 0) and (5, 0)',
        '• Vertex x-coordinate: (1 + 5)/2 = 3',
        '',
        'Ideal for launch trajectories where you know landing points!',
      ],
    );
  }

  Widget _buildParabolaProperties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🎪 Parabola Properties'),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Vertex',
          'The turning point of the parabola - maximum or minimum value.',
          'For f(x) = ax² + bx + c:\nVertex x-coordinate: x = -b/(2a)\nVertex y-coordinate: substitute x back into function\nExample: f(x) = x² - 4x + 3\nVertex: (2, -1)',
          const Color(0xFFEF4444),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Axis of Symmetry',
          'Vertical line that divides the parabola into mirror images.',
          'Equation: x = h (where h is vertex x-coordinate)\nExample: for vertex (2, -1)\nAxis of symmetry: x = 2\nParabola is symmetric about this line',
          const Color(0xFF10B981),
        ),
        const SizedBox(height: 15),
        _buildConceptCard(
          'Domain and Range',
          'Input and output values for quadratic functions.',
          'Domain: all real numbers (-∞, ∞)\nRange depends on vertex:\n• Opens up: [k, ∞) where k is vertex y-coordinate\n• Opens down: (-∞, k] where k is vertex y-coordinate',
          const Color(0xFF8B5CF6),
        ),
      ],
    );
  }

  Widget _buildSolvingMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🔧 Solving Quadratic Equations'),
        const SizedBox(height: 15),
        _buildOperationCard(
          'Factoring Method',
          'When the quadratic can be factored easily:',
          [
            'Factor into (x - r₁)(x - r₂) = 0',
            'Set each factor equal to zero',
            'Solve: x = r₁ or x = r₂',
            'Example: x² - 5x + 6 = (x - 2)(x - 3) = 0',
            'Solutions: x = 2 or x = 3',
          ],
          const Color(0xFF06B6D4),
        ),
        const SizedBox(height: 10),
        _buildOperationCard(
          'Quadratic Formula',
          'Universal method for any quadratic equation:',
          [
            'For ax² + bx + c = 0',
            'x = [-b ± √(b² - 4ac)] / (2a)',
            'Discriminant: Δ = b² - 4ac',
            'Δ > 0: two real solutions',
            'Δ = 0: one real solution',
            'Δ < 0: no real solutions',
          ],
          const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 10),
        _buildOperationCard(
          'Completing the Square',
          'Converting to vertex form:',
          [
            'Start with ax² + bx + c',
            'Factor out \'a\' from first two terms',
            'Add and subtract (b/2a)²',
            'Factor perfect square trinomial',
            'Results in a(x - h)² + k form',
          ],
          const Color(0xFFEC4899),
        ),
      ],
    );
  }

  Widget _buildPracticeProblems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('🚀 Practice Problems'),
        const SizedBox(height: 15),
        _buildPracticeCard(
          'Vertex and Axis of Symmetry',
          [
            '1. Find vertex of f(x) = x² - 6x + 8',
            '2. Find axis of symmetry for f(x) = 2x² + 4x - 1',
            '3. Convert f(x) = x² - 4x + 7 to vertex form',
          ],
          ['1) Vertex: (3, -1)', '2) x = -1', '3) f(x) = (x - 2)² + 3'],
          const Color(0xFF8B5CF6),
        ),
        const SizedBox(height: 10),
        _buildPracticeCard(
          'Solving Quadratic Equations',
          [
            '1. Solve: x² - 7x + 12 = 0 (by factoring)',
            '2. Solve: 2x² - 5x - 3 = 0 (quadratic formula)',
            '3. Find roots of f(x) = x² - 4x + 4',
          ],
          ['1) x = 3, x = 4', '2) x = 3, x = -1/2', '3) x = 2 (double root)'],
          const Color(0xFFEC4899),
        ),
        const SizedBox(height: 10),
        _buildPracticeCard(
          'Parabola Analysis',
          [
            '1. Does f(x) = -2x² + 4x - 1 open up or down?',
            '2. Find y-intercept of f(x) = 3x² - 5x + 2',
            '3. How many x-intercepts does f(x) = x² + 2x + 5 have?',
          ],
          [
            '1) Down (a = -2 < 0)',
            '2) y-intercept: (0, 2)',
            '3) None (Δ = -16 < 0)',
          ],
          const Color(0xFFF59E0B),
        ),
      ],
    );
  }

  Widget _buildGameConnection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899), Color(0xFFF59E0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 6),
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
                'Orbital Mechanics Mission 🛰️',
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
            'In this advanced orbital mission, you\'ll use quadratic equations to:',
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 16,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          ...[
            '• Calculate satellite orbital paths (parabolic trajectories)',
            '• Optimize spacecraft launch angles (vertex optimization)',
            '• Predict asteroid impact points (solving for roots)',
            '• Design gravity-assist maneuvers (completing the square)',
            '• Navigate through parabolic force fields (quadratic modeling)',
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
            'Master the curved mathematics of space! Every parabola you understand unlocks new orbital possibilities in the cosmic frontier.',
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
            // Navigator.pushNamed(context, '/level5_game');
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const GameScreen(level: 5), // Pass the level here
              ),
            );
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 12,
            shadowColor: const Color(0xFF8B5CF6).withValues(alpha: 0.6),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
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
            // Navigator.pushNamed(context, '/level5_game');
            /*
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => const GameScreen(level: 5), // Pass the level here
            ));
            */
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 8,
            shadowColor: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
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
              const Text('🌙', style: TextStyle(fontSize: 20)),
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
            const Color(0xFF2D1B4E).withValues(alpha: 0.8),
            const Color(0xFF1E1B4B).withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D1B4E).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            const Color(0xFF2D1B4E).withValues(alpha: 0.7),
            const Color(0xFF1E1B4B).withValues(alpha: 0.5),
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
            offset: const Offset(0, 4),
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
            const Color(0xFF2D1B4E).withValues(alpha: 0.7),
            const Color(0xFF1E1B4B).withValues(alpha: 0.5),
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
            const Color(0xFF2D1B4E).withValues(alpha: 0.8),
            const Color(0xFF1E1B4B).withValues(alpha: 0.6),
            const Color(0xFF0F0A2E).withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.2),
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
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.calculate, color: accentColor, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        level,
                        style: GoogleFonts.exo2(
                          color: accentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.2),
                      accentColor.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showAnswers = !_showAnswers;
                    });
                  },
                  icon: Icon(
                    _showAnswers ? Icons.visibility_off : Icons.visibility,
                    color: accentColor,
                    size: 16,
                  ),
                  label: Text(
                    _showAnswers ? 'Hide Solutions' : 'Show Solutions',
                    style: GoogleFonts.rajdhani(
                      color: accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1A0B2E).withValues(alpha: 0.6),
                  const Color(0xFF2D1B4E).withValues(alpha: 0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.quiz, color: Colors.white70, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Orbital Calculations:',
                      style: GoogleFonts.exo2(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...problems.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withValues(alpha: 0.3),
                                accentColor.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: GoogleFonts.rajdhani(
                                color: accentColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: GoogleFonts.rajdhani(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showAnswers) ...[
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.25),
                    accentColor.withValues(alpha: 0.15),
                    accentColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.5),
                  width: 2,
                ),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.3),
                              accentColor.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.lightbulb,
                          color: accentColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Mission Solutions:',
                        style: GoogleFonts.exo2(
                          color: accentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      Text('🛰️', style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: answers
                          .asMap()
                          .entries
                          .map(
                            (entry) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          accentColor.withValues(alpha: 0.4),
                                          accentColor.withValues(alpha: 0.2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: accentColor.withValues(
                                          alpha: 0.6,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: accentColor,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: GoogleFonts.rajdhani(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
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
