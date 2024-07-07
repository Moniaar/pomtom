import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomtom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: 20,
              child: Text(
                'Stay\nFocused,\nmotivated.',
                style: TextStyle(
                  color: Colors.white,
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
                  color: Colors.white,
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
                backgroundColor: Colors.deepPurple,
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
              bottom: -30, // Adjusted from 40 to 60 to move up
              right: -50,  // Added right positioning
              left: 100,
              top: 5,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FocusTimerScreen()),
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



class FocusTimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F0B29),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Text(
              'Welcome, dear student!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CircularPercentIndicator(
              radius: 150.0,
              lineWidth: 13.0,
              animation: true,
              percent: 0.5,
              center: Text(
                "9:54",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48.0,
                  color: Colors.white,
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.white,
              progressColor: Colors.deepPurpleAccent,
            ),
            SizedBox(height: 20),
            Text(
              "Let's focus for a bit and reward ourselves later!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1C1142),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Finish',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}