import 'package:flutter/material.dart';

class ArchitectureScreen extends StatefulWidget {
  const ArchitectureScreen({super.key});

  @override
  State<ArchitectureScreen> createState() => _ArchitectureScreenState();
}

class _ArchitectureScreenState extends State<ArchitectureScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Architecture Screen"),
    );
  }
}
