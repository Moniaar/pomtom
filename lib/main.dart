import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/services.dart'; // For chat icons

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomtom',
      theme: isDarkMode
          ? ThemeData.dark()
          : ThemeData(
              primaryColor: Colors.deepPurple,
              scaffoldBackgroundColor: Colors.white,
              textTheme: const TextTheme(
                displayLarge: TextStyle(color: Colors.black),
                bodyLarge: TextStyle(color: Colors.black),
                bodyMedium: TextStyle(color: Colors.black54),
              ),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
                  .copyWith(secondary: Colors.deepPurpleAccent)
                  .copyWith(background: Colors.white),
            ),
      home: MainPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

class MainPage extends StatelessWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  MainPage({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: 20,
              child: Text(
                'Stay\nFocused,\nmotivated.',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 400,
              left: 20,
              child: Text(
                "Let's focus for a\nbit and reward\nourselves later!",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black54,
                  fontSize: 18,
                  fontFamily: 'DancingScript',
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 10,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: isDarkMode ? Colors.deepPurple : Colors.deepPurple[200],
                child: IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    toggleTheme();
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 130,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepOrangeAccent,
              ),
            ),
            Positioned(
              bottom: -30,
              right: -50,
              left: 100,
              top: 5,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TimerNavigation(
                              toggleTheme: toggleTheme, isDarkMode: isDarkMode)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(103, 58, 183, 1),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerNavigation extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  TimerNavigation({required this.toggleTheme, required this.isDarkMode});

  @override
  _TimerNavigationState createState() => _TimerNavigationState();
}

class _TimerNavigationState extends State<TimerNavigation> {
  int _currentIndex = 0;
  int _focusDuration = 600; // default to 10 minutes
  int _breakDuration = 300; // default to 5 minutes

  final List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    _children.add(FocusTimerScreen(
      isDarkMode: widget.isDarkMode,
      focusDuration: _focusDuration,
      breakDuration: _breakDuration,
    ));
    _children.add(ComingSoonScreen());
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
              color: Colors.purple,
            ),
            onPressed: () {
              widget.toggleTheme();
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        child: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.timer),
              label: 'Timer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent), // Use a suitable copilot icon
              label: 'Coming Soon',
            ),
          ],
        ),
      ),
    );
  }
}

class FocusTimerScreen extends StatefulWidget {
  final bool isDarkMode;
  final int focusDuration;
  final int breakDuration;

  FocusTimerScreen({
    required this.isDarkMode,
    required this.focusDuration,
    required this.breakDuration,
  });

  @override
  _FocusTimerScreenState createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late int _focusRemainingTime;
  late int _breakRemainingTime;
  bool _isFocusRunning = false;
  bool _isBreakRunning = false;

  late AnimationController _glowController;
  late Animation<Color?> _glowAnimation;

  final TextEditingController _focusController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _focusRemainingTime = widget.focusDuration;
    _breakRemainingTime = widget.breakDuration;

    _glowController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = ColorTween(
      begin: Colors.deepPurpleAccent,
      end: Colors.transparent,
    ).animate(_glowController);
  }

  @override
  void dispose() {
    _timer.cancel();
    _glowController.dispose();
    super.dispose();
  }

  void _startFocusTimer() {
    if (_isFocusRunning || _isBreakRunning) return;

    setState(() {
      _isFocusRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_focusRemainingTime > 0) {
        setState(() {
          _focusRemainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isFocusRunning = false;
        });
        _startBreakTimer();
      }
    });
  }

  void _startBreakTimer() {
    if (_isBreakRunning) return;

    setState(() {
      _isBreakRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_breakRemainingTime > 0) {
        setState(() {
          _breakRemainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isBreakRunning = false;
        });
        _resetTimers();
      }
    });
  }

  void _pauseTimer() {
    _timer.cancel();
    setState(() {
      _isFocusRunning = false;
      _isBreakRunning = false;
    });
  }

  void _resetTimers() {
    setState(() {
      _focusRemainingTime = widget.focusDuration;
      _breakRemainingTime = widget.breakDuration;
      _isFocusRunning = false;
      _isBreakRunning = false;
    });
  }

  void _updateFocusDuration() {
    final newFocusDuration = int.tryParse(_focusController.text) ?? widget.focusDuration ~/ 60;
    setState(() {
      _focusRemainingTime = newFocusDuration * 60;
      _focusController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Focus Timer',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 125.0,
              lineWidth: 12.0,
              animation: false,
              percent: _isFocusRunning
                  ? _focusRemainingTime / widget.focusDuration
                  : _isBreakRunning
                      ? _breakRemainingTime / widget.breakDuration
                      : 1.0,
              center: Text(
                _isFocusRunning
                    ? '${(_focusRemainingTime ~/ 60).toString().padLeft(2, '0')}:${(_focusRemainingTime % 60).toString().padLeft(2, '0')}'
                    : _isBreakRunning
                        ? '${(_breakRemainingTime ~/ 60).toString().padLeft(2, '0')}:${(_breakRemainingTime % 60).toString().padLeft(2, '0')}'
                        : '00:00',
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: widget.isDarkMode
                  ? Colors.deepPurpleAccent
                  : Colors.deepPurple,
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: _isFocusRunning || _isBreakRunning
                  ? _pauseTimer
                  : _startFocusTimer,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.deepPurple, Colors.deepPurple.withOpacity(0)],
                    stops: [0.5, 2.0],
                    center: Alignment.center,
                    radius: 0.5,
                  ),
                ),
                child: ScaleTransition(
                  scale: Tween(begin: 0.9, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _glowController,
                      curve: Curves.easeInOut,
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) => Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _glowAnimation.value,
                      ),
                      child: Icon(
                        _isFocusRunning || _isBreakRunning
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ComingSoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Tutor'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                ChatBubble(
                  text: "Hello! I'm your AI Personal Assistance. How can I help you today?",
                  isUser: false,
                ),
                // Add more ChatBubble widgets here to simulate conversation
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Implement message sending functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurple : Colors.grey[300],
          borderRadius: isUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}
