import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
 
  @override
  State<MyApp> createState() => _MyAppState();
}
 
class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late final MeshGradientController _controller;
 
  @override
  void initState() {
    super.initState();
    _controller = MeshGradientController(
      points: [
        MeshGradientPoint(
            position: const Offset(
              -1,
              0.2,
            ),
            color: const Color.fromARGB(255, 200, 215, 255)),
        MeshGradientPoint(
          position: const Offset(
            
            -1,
            -1,
          ),
          color: const Color.fromARGB(255, 221, 255, 200),
        ),
        MeshGradientPoint(
          position: const Offset(
            -1,
            -1,
          ),
          color: const Color.fromARGB(255, 251, 200, 255),
        ),
        MeshGradientPoint(
          position: const Offset(
            -1,
            -1,
          ),
          color: const Color.fromARGB(255, 255, 246, 200),
        ),
        MeshGradientPoint(
          position: const Offset(
            0.2,
            0.7,
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ],
      vsync: this,
    );
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'mesh_gradient example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: MeshGradient(
                controller: _controller,
                options: MeshGradientOptions(
                  blend: 3.5,
                  noiseIntensity: 0.5,
                ),
              ),
            ),
            Positioned.fill(
              bottom: 100,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    // MeshGradientController functions are async, so you can await them
                    await _controller.animateSequence(
                      duration: const Duration(seconds: 4),
                      sequences: [
                        AnimationSequence(
                          pointIndex: 0,
                          newPoint: MeshGradientPoint(
                            position: Offset(
                              Random().nextDouble() * 2 - 0.5,
                              Random().nextDouble() * 2 - 0.5,
                            ),
                            color: _controller.points.value[0].color,
                          ),
                          interval: const Interval(
                            0,
                            0.5,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        AnimationSequence(
                          pointIndex: 1,
                          newPoint: MeshGradientPoint(
                            position: Offset(
                              Random().nextDouble() * 2 - 0.5,
                              Random().nextDouble() * 2 - 0.5,
                            ),
                            color: _controller.points.value[1].color,
                          ),
                          interval: const Interval(
                            0.25,
                            0.75,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        AnimationSequence(
                          pointIndex: 2,
                          newPoint: MeshGradientPoint(
                            position: Offset(
                              Random().nextDouble() * 2 - 0.5,
                              Random().nextDouble() * 2 - 0.5,
                            ),
                            color: _controller.points.value[2].color,
                          ),
                          interval: const Interval(
                            0.5,
                            1,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        AnimationSequence(
                          pointIndex: 3,
                          newPoint: MeshGradientPoint(
                            position: Offset(
                              Random().nextDouble() * 2 - 0.5,
                              Random().nextDouble() * 2 - 0.5,
                            ),
                            color: _controller.points.value[3].color,
                          ),
                          interval: const Interval(
                            0.75,
                            1,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        AnimationSequence(
                          pointIndex: 4,
                          newPoint: MeshGradientPoint(
                            position: Offset(
                              Random().nextDouble() * 2 - 0.5,
                              Random().nextDouble() * 2 - 0.5,
                            ),
                            color: _controller.points.value[3].color,
                          ),
                          interval: const Interval(
                            0.95,
                            1,
                            curve: Curves.easeInOut,
                          ),
                        ),
                      ],
                    );
                  },
                  child: const Text("Animate"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}