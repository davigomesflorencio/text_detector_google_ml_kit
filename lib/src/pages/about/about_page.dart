import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/icon.png'),
              width: 40,
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              'Sobre',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            )
          ],
        ),
        backgroundColor: Color.fromARGB(100, 3, 169, 244),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // App Logo/Icon
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Image(
                  image: AssetImage('assets/icon.png'),
                  width: 60,
                  height: 60,
                ),
              ),
              const SizedBox(height: 20),

              // App Name
              Text(
                ' Text Detector MLKIT',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),

              // App Description
              const Text(
                "O Text Detector MLKit é um aplicativo desenvolvido para demonstrar a utilização da API de reconhecimento de textos do ML Kit para Flutter do Google. "
                "Esta política de privacidade explica como coletamos, usamos, armazenamos e protegemos suas informações ao utilizar nosso aplicativo."
                "Nosso compromisso é garantir a transparência e a segurança dos dados dos usuários, seguindo as melhores práticas de privacidade e as diretrizes do Google ML Kit.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              const Icon(Icons.info),
              ListTile(
                title: const Text(
                  'Version',
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                  '2.5.0',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
