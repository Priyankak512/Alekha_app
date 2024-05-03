import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:alekha/create_pdf/create_pdf_from_data.dart';
import 'package:alekha/create_pdf/pdf_screen.dart';
import 'package:alekha/gradient_color_screen.dart';

class CurverdBottomSheet extends StatelessWidget {
  CurverdBottomSheet({super.key});
  final _pageController = PageController();

  void dispose() {
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Curved Navigation Bar'),
          backgroundColor: const Color.fromARGB(255, 255, 240, 219),
          foregroundColor: Colors.black,
        ),
        body: PageView(
          controller: _pageController,
          children: const <Widget>[
            CreatePdfFromData(),
            PdfScreen(),
            GradientColorScreen(),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: const Color.fromARGB(255, 206, 193, 238),
          color: const Color.fromARGB(255, 232, 230, 238),
          height: 75,
          animationDuration: const Duration(milliseconds: 300),
          items: const <Widget>[
            Icon(
              Icons.person_add_alt_1,
              size: 30,
              color: Color.fromARGB(255, 39, 38, 38),
            ),
            Icon(
              Icons.home_rounded,
              size: 30,
              color: Color.fromARGB(255, 39, 38, 38),
            ),
            Icon(
              Icons.feed,
              size: 30,
              color: Color.fromARGB(255, 39, 38, 38),
            ),
          ],
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut);
          },
        ),
      ),
    );
  }
}
