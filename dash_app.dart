import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(DashApp());
}

class DashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dash',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
      ),
      home: DashHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class User {
  String username;
  String email;
  String password;
  int level;
  int experience;
  List<String> achievements;
  List<int> completedLevels;
  int streakDays;
  int totalPoints;

  User({
    required this.username,
    required this.email,
    required this.password,
    this.level = 1,
    this.experience = 0,
    this.achievements = const [],
    this.completedLevels = const [],
    this.streakDays = 0,
    this.totalPoints = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'level': level,
      'experience': experience,
      'achievements': achievements,
      'completedLevels': completedLevels,
      'streakDays': streakDays,
      'totalPoints': totalPoints,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      level: json['level'] ?? 1,
      experience: json['experience'] ?? 0,
      achievements: List<String>.from(json['achievements'] ?? []),
      completedLevels: List<int>.from(json['completedLevels'] ?? []),
      streakDays: json['streakDays'] ?? 0,
      totalPoints: json['totalPoints'] ?? 0,
    );
  }
}

class Level {
  int id;
  String title;
  String description;
  String difficulty;
  int xpReward;
  String badge;
  List<String> topics;
  bool unlocked;

  Level({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.xpReward,
    required this.badge,
    required this.topics,
    this.unlocked = false,
  });
}

class Question {
  String question;
  List<String> options;
  int correct;
  String explanation;

  Question({
    required this.question,
    required this.options,
    required this.correct,
    required this.explanation,
  });
}

class Achievement {
  int id;
  String name;
  String description;
  String icon;
  bool earned;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.earned = false,
  });
}

class QuizResult {
  String question;
  int userAnswer;
  int correct;
  bool isCorrect;
  String explanation;

  QuizResult({
    required this.question,
    required this.userAnswer,
    required this.correct,
    required this.isCorrect,
    required this.explanation,
  });
}

class DashHome extends StatefulWidget {
  @override
  _DashHomeState createState() => _DashHomeState();
}

class _DashHomeState extends State<DashHome> {
  User? currentUser;
  bool showLogin = true;
  bool isRegistering = false;
  String currentView = 'dashboard';
  Level? selectedLevel;
  int currentQuestion = 0;
  int? userAnswer;
  bool showResult = false;
  List<QuizResult> quizResults = [];
  
  // Form controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController regUsernameController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();

  // Demo user data
  Map<String, User> users = {
    'demo': User(
      username: 'demo',
      email: 'demo@example.com',
      password: 'demo123',
      level: 1,
      experience: 850,
      achievements: ['First Steps', 'Quick Learner'],
      completedLevels: [1, 2],
      streakDays: 5,
      totalPoints: 850,
    ),
  };

  List<Level> levels = [
    Level(
      id: 1,
      title: "Basic Operations",
      description: "Master addition, subtraction, multiplication, and division with variables",
      difficulty: "Beginner",
      xpReward: 100,
      badge: "🔢",
      topics: ["Variables", "Basic Operations", "Order of Operations"],
      unlocked: true,
    ),
    Level(
      id: 2,
      title: "Linear Equations",
      description: "Solve one-step and two-step linear equations",
      difficulty: "Beginner",
      xpReward: 150,
      badge: "📐",
      topics: ["One-step equations", "Two-step equations", "Variables on both sides"],
      unlocked: true,
    ),
    Level(
      id: 3,
      title: "Graphing Lines",
      description: "Plot points and graph linear equations",
      difficulty: "Intermediate",
      xpReward: 200,
      badge: "📊",
      topics: ["Coordinate plane", "Slope", "Y-intercept", "Graphing"],
      unlocked: false,
    ),
    Level(
      id: 4,
      title: "Systems of Equations",
      description: "Solve systems using substitution and elimination",
      difficulty: "Intermediate",
      xpReward: 250,
      badge: "🔄",
      topics: ["Substitution method", "Elimination method", "Graphing systems"],
      unlocked: false,
    ),
    Level(
      id: 5,
      title: "Quadratic Functions",
      description: "Explore parabolas and quadratic equations",
      difficulty: "Advanced",
      xpReward: 300,
      badge: "🌟",
      topics: ["Parabolas", "Vertex form", "Factoring", "Quadratic formula"],
      unlocked: false,
    ),
    Level(
      id: 6,
      title: "Polynomials",
      description: "Add, subtract, multiply, and factor polynomials",
      difficulty: "Advanced",
      xpReward: 350,
      badge: "🎯",
      topics: ["Polynomial operations", "Factoring", "Special products"],
      unlocked: false,
    ),
  ];

  List<Achievement> achievements = [
    Achievement(
      id: 1,
      name: "First Steps",
      description: "Complete your first level",
      icon: "👶",
      earned: true,
    ),
    Achievement(
      id: 2,
      name: "Quick Learner",
      description: "Score 90% or higher on a quiz",
      icon: "⚡",
      earned: true,
    ),
    Achievement(
      id: 3,
      name: "Streak Master",
      description: "Maintain a 7-day learning streak",
      icon: "🔥",
      earned: false,
    ),
    Achievement(
      id: 4,
      name: "Perfect Score",
      description: "Get 100% on a quiz",
      icon: "💯",
      earned: false,
    ),
    Achievement(
      id: 5,
      name: "Level Crusher",
      description: "Complete 3 levels",
      icon: "💪",
      earned: false,
    ),
    Achievement(
      id: 6,
      name: "Math Wizard",
      description: "Complete all levels",
      icon: "🧙‍♂️",
      earned: false,
    ),
  ];

  List<Question> generateQuestions(int levelId) {
    Map<int, List<Question>> questionSets = {
      1: [
        Question(
          question: "Solve for x: 3x + 5 = 14",
          options: ["x = 3", "x = 4", "x = 5", "x = 6"],
          correct: 0,
          explanation: "Subtract 5 from both sides: 3x = 9, then divide by 3: x = 3",
        ),
        Question(
          question: "Simplify: 2x + 3x - x",
          options: ["4x", "5x", "6x", "3x"],
          correct: 0,
          explanation: "Combine like terms: 2x + 3x - x = (2 + 3 - 1)x = 4x",
        ),
        Question(
          question: "If x = 4, what is 2x + 7?",
          options: ["15", "16", "14", "13"],
          correct: 0,
          explanation: "Substitute x = 4: 2(4) + 7 = 8 + 7 = 15",
        ),
        Question(
          question: "Solve: x - 8 = 12",
          options: ["x = 20", "x = 4", "x = -4", "x = 8"],
          correct: 0,
          explanation: "Add 8 to both sides: x = 12 + 8 = 20",
        ),
        Question(
          question: "What is the coefficient of x in 5x + 3?",
          options: ["5", "3", "8", "x"],
          correct: 0,
          explanation: "The coefficient is the number multiplied by the variable, which is 5",
        ),
      ],
      2: [
        Question(
          question: "Solve: 2x + 6 = 18",
          options: ["x = 6", "x = 12", "x = 8", "x = 4"],
          correct: 0,
          explanation: "Subtract 6: 2x = 12, then divide by 2: x = 6",
        ),
        Question(
          question: "Solve: 4x - 7 = 25",
          options: ["x = 8", "x = 7", "x = 9", "x = 6"],
          correct: 0,
          explanation: "Add 7: 4x = 32, then divide by 4: x = 8",
        ),
        Question(
          question: "Solve: 3(x + 2) = 21",
          options: ["x = 5", "x = 6", "x = 7", "x = 4"],
          correct: 0,
          explanation: "Distribute: 3x + 6 = 21, subtract 6: 3x = 15, divide by 3: x = 5",
        ),
        Question(
          question: "Solve: 2x + 3 = x + 8",
          options: ["x = 5", "x = 4", "x = 6", "x = 3"],
          correct: 0,
          explanation: "Subtract x from both sides: x + 3 = 8, subtract 3: x = 5",
        ),
        Question(
          question: "Solve: 5x - 4 = 3x + 10",
          options: ["x = 7", "x = 6", "x = 8", "x = 5"],
          correct: 0,
          explanation: "Subtract 3x: 2x - 4 = 10, add 4: 2x = 14, divide by 2: x = 7",
        ),
      ],
    };
    return questionSets[levelId] ?? questionSets[1]!;
  }

  void handleLogin() {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    
    if (username.isEmpty || password.isEmpty) {
      _showAlert('Please fill in all fields');
      return;
    }

    User? user = users[username];
    if (user != null && user.password == password) {
      setState(() {
        currentUser = user;
        showLogin = false;
        currentView = 'dashboard';
      });
      _clearLoginForm();
    } else {
      _showAlert('Invalid credentials. Try username: demo, password: demo123');
    }
  }

  void handleRegister() {
    String username = regUsernameController.text.trim();
    String email = emailController.text.trim();
    String password = regPasswordController.text.trim();
    
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showAlert('Please fill in all fields');
      return;
    }

    if (users.containsKey(username)) {
      _showAlert('Username already exists');
      return;
    }

    User newUser = User(
      username: username,
      email: email,
      password: password,
    );

    setState(() {
      users[username] = newUser;
      currentUser = newUser;
      showLogin = false;
      currentView = 'dashboard';
    });
    _clearRegisterForm();
  }

  void _clearLoginForm() {
    usernameController.clear();
    passwordController.clear();
  }

  void _clearRegisterForm() {
    regUsernameController.clear();
    emailController.clear();
    regPasswordController.clear();
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void handleLogout() {
    setState(() {
      currentUser = null;
      showLogin = true;
      currentView = 'dashboard';
    });
  }

  void startQuiz(Level level) {
    setState(() {
      selectedLevel = level;
      currentQuestion = 0;
      userAnswer = null;
      showResult = false;
      quizResults = [];
      currentView = 'quiz';
    });
  }

  void submitAnswer() {
    if (userAnswer == null) return;

    List<Question> questions = generateQuestions(selectedLevel!.id);
    Question currentQ = questions[currentQuestion];
    bool isCorrect = userAnswer == currentQ.correct;
    
    QuizResult result = QuizResult(
      question: currentQ.question,
      userAnswer: userAnswer!,
      correct: currentQ.correct,
      isCorrect: isCorrect,
      explanation: currentQ.explanation,
    );
    
    setState(() {
      quizResults.add(result);
      showResult = true;
    });
    
    Future.delayed(Duration(seconds: 2), () {
      if (currentQuestion + 1 < questions.length) {
        setState(() {
          currentQuestion++;
          userAnswer = null;
          showResult = false;
        });
      } else {
        completeQuiz();
      }
    });
  }

  void completeQuiz() {
    int correctAnswers = quizResults.where((r) => r.isCorrect).length;
    double percentage = (correctAnswers / quizResults.length) * 100;
    int xpGained = (percentage * 2).floor();
    
    setState(() {
      currentUser!.experience += xpGained;
      currentUser!.totalPoints += xpGained;
      
      if (percentage >= 70 && !currentUser!.completedLevels.contains(selectedLevel!.id)) {
        currentUser!.completedLevels.add(selectedLevel!.id);
        currentUser!.level = currentUser!.level > selectedLevel!.id ? currentUser!.level : selectedLevel!.id + 1;
      }
      
      users[currentUser!.username] = currentUser!;
      currentView = 'results';
    });
  }

  Color getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6B46C1),
                Color(0xFF1E40AF),
                Color(0xFF3730A3),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '🎯',
                        style: TextStyle(fontSize: 48),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Dash',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Master algebra through gamified learning',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      if (!isRegistering) ...[
                        // Login Form
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6B46C1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isRegistering = true;
                            });
                          },
                          child: Text(
                            'Create new account',
                            style: TextStyle(
                              color: Color(0xFF6B46C1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Demo Account:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Username: demo',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                'Password: demo123',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Register Form
                        TextField(
                          controller: regUsernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: regPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isRegistering = false;
                            });
                          },
                          child: Text(
                            'Back to sign in',
                            style: TextStyle(
                              color: Color(0xFF6B46C1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('🎯', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              'Dash',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF6B46C1),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                currentView = 'dashboard';
              });
            },
            icon: Icon(
              Icons.dashboard,
              color: currentView == 'dashboard' ? Colors.yellow : Colors.white70,
            ),
            label: Text(
              'Dashboard',
              style: TextStyle(
                color: currentView == 'dashboard' ? Colors.yellow : Colors.white70,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              setState(() {
                currentView = 'achievements';
              });
            },
            icon: Icon(
              Icons.emoji_events,
              color: currentView == 'achievements' ? Colors.yellow : Colors.white70,
            ),
            label: Text(
              'Achievements',
              style: TextStyle(
                color: currentView == 'achievements' ? Colors.yellow : Colors.white70,
              ),
            ),
          ),
          IconButton(
            onPressed: handleLogout,
            icon: Icon(Icons.logout, color: Colors.white70),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF3F4F6),
              Color(0xFFE5E7EB),
            ],
          ),
        ),
        child: _buildCurrentView(),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (currentView) {
      case 'dashboard':
        return _buildDashboard();
      case 'quiz':
        return _buildQuiz();
      case 'results':
        return _buildResults();
      case 'achievements':
        return _buildAchievements();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Stats Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6B46C1), Color(0xFF1E40AF)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, ${currentUser!.username}!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Level ${currentUser!.level} • ${currentUser!.experience} XP',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      '${currentUser!.completedLevels.length}',
                      'Levels Complete',
                    ),
                    _buildStatItem(
                      '${currentUser!.achievements.length}',
                      'Achievements',
                    ),
                    _buildStatItem(
                      '${currentUser!.streakDays}',
                      'Day Streak',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          
          // Levels Section
          Text(
            'Choose Your Quest',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: levels.length,
            itemBuilder: (context, index) {
              Level level = levels[index];
              bool isUnlocked = level.unlocked || 
                  currentUser!.completedLevels.contains(level.id - 1) || 
                  level.id == 1;
              bool isCompleted = currentUser!.completedLevels.contains(level.id);
              
              return GestureDetector(
                onTap: isUnlocked ? () => startQuiz(level) : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Opacity(
                    opacity: isUnlocked ? 1.0 : 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              level.badge,
                              style: TextStyle(fontSize: 32),
                            ),
                            Icon(
                              isCompleted)
                            ]
                          }
                  )
              }
          }
    }
}
