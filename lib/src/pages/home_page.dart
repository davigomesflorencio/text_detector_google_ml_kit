import 'package:flutter/material.dart';
import 'package:text_detector_google_ml_kit/src/pages/text_recognizer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const TextRecognizerPage();
  }
}
