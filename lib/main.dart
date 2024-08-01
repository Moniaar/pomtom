import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/timer_navigation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:myapp/login.dart';

void main() {
  runApp(MyApp());
}

bool _isLoggedIn = false;
String _username = '';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;
  bool _isLoggedIn = false;
  String _username = '';

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

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
                              toggleTheme: toggleTheme, isDarkMode: isDarkMode, username: '$username',)),
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
          ],
        ),
      ),
    );
  }
}


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

class _TimerNavigationState extends State<TimerNavigation>
    with SingleTickerProviderStateMixin {
  bool _isFocusRunning = false;
  bool _isBreakRunning = false;
  late int _focusRemainingTime;
  late int _breakRemainingTime;
  late AnimationController _glowController;
  late Animation<Color?> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _focusRemainingTime = widget.focusDuration;
    _breakRemainingTime = widget.breakDuration;
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = ColorTween(
      begin: Colors.deepPurple.withOpacity(0.5),
      end: Colors.deepPurple,
    ).animate(_glowController);
  }

  void _startFocusTimer() {
    setState(() {
      _isFocusRunning = true;
      _isBreakRunning = false;
      _focusRemainingTime = widget.focusDuration;
    });
    // Add your timer logic here
  }

  void _pauseTimer() {
    setState(() {
      _isFocusRunning = false;
      _isBreakRunning = false;
    });
    // Add your pause logic here
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
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
              'Focus Timer - Hello, ${widget.username}',
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
          title: const Text('Bot'),
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
                        label: const Text("Ask Gemini..."),
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
