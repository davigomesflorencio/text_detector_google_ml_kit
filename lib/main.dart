import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:text_detector_google_ml_kit/src/pages/about/about_page.dart';
import 'package:text_detector_google_ml_kit/src/pages/home/text_recognizer_page.dart';
import 'package:text_detector_google_ml_kit/src/pages/privacy/policy_privacy_page.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Color.fromARGB(100, 3, 169, 244),
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => SafeArea(child: TextRecognizerPage()),
        "/privacy": (context) => SafeArea(child: PolicyPrivacyPage()),
        "/about": (context) => SafeArea(child: AboutPage()),
      },
    );
  }
}
