import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DigitalPictureFrame(),
    );
  }
}

class DigitalPictureFrame extends StatefulWidget {
  const DigitalPictureFrame({super.key});

  @override
  State<DigitalPictureFrame> createState() => _DigitalPictureFrameState();
}

class _DigitalPictureFrameState extends State<DigitalPictureFrame> {
  final List<String> imageUrls = [
    'https://jaymehta-pineapple-frame.s3.us-east-1.amazonaws.com/pineapple1.jpg',
    'https://jaymehta-pineapple-frame.s3.us-east-1.amazonaws.com/pineapple2.png',
    'https://jaymehta-pineapple-frame.s3.us-east-1.amazonaws.com/pineapple3.jpg',
    'https://jaymehta-pineapple-frame.s3.us-east-1.amazonaws.com/pineapple4.jpg',
  ];

  int currentIndex = 0;
  bool isPaused = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  void _startImageRotation() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!isPaused) {
        setState(() {
          currentIndex = (currentIndex + 1) % imageUrls.length;
        });
      }
    });
  }

  void _togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🍍 Pineapple Picture Frame"),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amberAccent, width: 20),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(color: Colors.amber, blurRadius: 25, spreadRadius: 2),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1), // fade animation duration
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: Image.network(
                imageUrls[currentIndex],
                key: ValueKey<String>(imageUrls[currentIndex]),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 400,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amberAccent,
                          ),
                        );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      "🍍 Unable to load image",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isPaused ? Colors.green : Colors.redAccent,
        onPressed: _togglePause,
        child: Icon(isPaused ? Icons.play_arrow : Icons.pause),
      ),
    );
  }
}
