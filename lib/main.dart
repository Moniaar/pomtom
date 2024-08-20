import 'dart:async';
import 'package:flutter/material.dart';
// The module responsiable for animation decreasing
import 'package:percent_indicator/percent_indicator.dart';
// To make the API From Gemini work
import 'package:http/http.dart' as http;
import 'dart:convert';
// Google generative AI 
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart'; // For date formatting
// Importing the login page
import 'package:myapp/login.dart';

void main() {
  runApp(MyApp());
}

// Assuming that the user isn't signed in initially
bool _isLoggedIn = false;
String _username = '';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// Making the main login page dark theme
class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;
  bool _isLoggedIn = false;
  String _username = '';

// To make the toggle switch themes when the user clicks
  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

// Take the username and set it to _username
  void _handleLogin(String username) {
    setState(() {
      _isLoggedIn = true;
      _username = username;
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
      home: _isLoggedIn
          ? MainPage(toggleTheme: toggleTheme, isDarkMode: isDarkMode, username: _username)
          : LoginPage(onLogin: _handleLogin),
    );
  }
}


class MainPage extends StatelessWidget {
  final Function toggleTheme;
  final bool isDarkMode;
  final String username;

  MainPage({required this.toggleTheme, required this.isDarkMode, required this.username});

// App welcome page
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
                  color: isDarkMode ? Colors.white : Color.fromARGB(201, 0, 0, 0),
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
              bottom: 50,
              left: 110,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromARGB(204, 255, 109, 64),
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
                              toggleTheme: toggleTheme, isDarkMode: isDarkMode, username: '$username',)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(103, 58, 183, 1),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
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
          ],
        ),
      ),
    );
  }
}

// Timer window navigation
class TimerNavigation extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;
  final String username;
  final int focusDuration;
  final int breakDuration;

  TimerNavigation({
    required this.toggleTheme,
    required this.isDarkMode,
    required this.username,
    this.focusDuration = 1500, // Default 25 minutes
    this.breakDuration = 300,  // Default 5 minutes
  });

  @override
  _TimerNavigationState createState() => _TimerNavigationState();
}

// Creating the class for the timer and initalizing the variables
class _TimerNavigationState extends State<TimerNavigation>
    with SingleTickerProviderStateMixin {
  bool _isFocusRunning = false;
  bool _isBreakRunning = false;
  bool _isPaused = false;
  late int _focusRemainingTime;
  late int _breakRemainingTime;
  late int _customFocusTime;
  late int _customBreakTime;
  late AnimationController _glowController;
  late Animation<Color?> _glowAnimation;
  Timer? _timer;
  int _selectedIndex = 0;

// the init state for all variables
  @override
  void initState() {
    super.initState();
    _focusRemainingTime = widget.focusDuration;
    _breakRemainingTime = widget.breakDuration;
    _customFocusTime = widget.focusDuration;
    _customBreakTime = widget.breakDuration;
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

// Indicating that the color of the glow should change
    _glowAnimation = ColorTween(
      begin: Colors.deepPurple.withOpacity(0.5),
      end: Colors.deepPurple,
    ).animate(_glowController);
  }

  void _startFocusTimer() {
    setState(() {
      _isFocusRunning = true;
      _isBreakRunning = false;
      _isPaused = false;
      _focusRemainingTime = _customFocusTime;
    });
    _startTimer();
  }

// function to start the timer and pause when the user clicks the pause button below
// without switching to the break or starting from the beginning
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_isFocusRunning && !_isPaused) {
          if (_focusRemainingTime > 0) {
            _focusRemainingTime--;
          } else {
            _isFocusRunning = false;
            _isBreakRunning = true;
            _focusRemainingTime = _customFocusTime;
          }
        } else if (_isBreakRunning && !_isPaused) {
          if (_breakRemainingTime > 0) {
            _breakRemainingTime--;
          } else {
            _isBreakRunning = false;
            _breakRemainingTime = _customBreakTime;
          }
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

// When the user clicks in the clock a window should appear to ask him to enter cutom time
  void _showCustomTimeDialog() {
    int? focusTime;
    int? breakTime;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Set Custom Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Focus Time (minutes)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                focusTime = int.tryParse(value);
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Break Time (minutes)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                breakTime = int.tryParse(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // Making sure it's all in minutes
                if (focusTime != null) {
                  _customFocusTime = focusTime! * 60;
                  _focusRemainingTime = _customFocusTime;
                }
                if (breakTime != null) {
                  _customBreakTime = breakTime! * 60;
                  _breakRemainingTime = _customBreakTime;
                }
              });
            },
            child: Text('Set'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildTimerScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
           'Hello, ${widget.username}',
            style: TextStyle(
              color: widget.isDarkMode ? Colors.white : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _showCustomTimeDialog,
            child: CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 12.0,
              animation: false, // Disable the animation for a smoother transition
              percent: _isFocusRunning
                  ? _focusRemainingTime / _customFocusTime
                  : _isBreakRunning
                      ? _breakRemainingTime / _customBreakTime
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
                          ? _isPaused ? Icons.play_arrow : Icons.pause
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
    );
  }

  Widget _buildChatBotScreen() {
    return const BotScreen();
  }

// Navigation bar for the timer and the study buddy
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
      body: _selectedIndex == 0 ? _buildTimerScreen() : _buildChatBotScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Study Buddy',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Bot screen for the study buddy
class BotScreen extends StatefulWidget {
  const BotScreen({super.key});

  @override
  State<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {
  final TextEditingController _userMessage = TextEditingController();

  static const apiKey = "AIzaSyCmxiF-wOE4sXN5aY3smg8cZF-UcwnoUh4";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();
// setting the format of the messages

    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Study buddy'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                  );
                },
              ),
            ),
            // messages Ui
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      controller: _userMessage,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.deepOrange),
                            borderRadius: BorderRadius.circular(50)),
                        label: const Text("Ask me someting..."),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: const EdgeInsets.all(15),
                    iconSize: 30,
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.deepPurple),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all(
                        const CircleBorder(),
                      ),
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  const Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});

// More on messages UI below handling both light/dark theme
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
        color: isUser ? Colors.deepPurple : Colors.grey.shade200,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(30),
          bottomLeft: isUser ? const Radius.circular(30) : Radius.zero,
          topRight: const Radius.circular(30),
          bottomRight: isUser ? Radius.zero : const Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
          Text(
            date,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
        ],
      ),
    );
  }
}

// Define the message class
class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}
