import 'package:flutter/material.dart';

class GradientColorScreen extends StatefulWidget {
  const GradientColorScreen({super.key});

  @override
  State<GradientColorScreen> createState() => _GradientColorScreenState();
}

class _GradientColorScreenState extends State<GradientColorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal, Colors.teal.shade200],
        ),
      ),
      child: const Center(
        child: Text(
          'Gradient Container',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }
}
