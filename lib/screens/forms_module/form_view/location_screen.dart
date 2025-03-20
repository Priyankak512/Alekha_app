import 'package:flutter/material.dart';

class InteriorScreen extends StatefulWidget {
  const InteriorScreen({super.key});

  @override
  State<InteriorScreen> createState() => _InteriorScreenState();
}

class _InteriorScreenState extends State<InteriorScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Location Screen"),
    );
  }
}
