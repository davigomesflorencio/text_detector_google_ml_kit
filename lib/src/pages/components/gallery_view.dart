// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({Key? key, required this.title, this.text, required this.onImage, required this.onDetectorViewModeChanged})
      : super(key: key);

  final String title;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function()? onDetectorViewModeChanged;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;
  bool _isProcessing = false;
  String _version = 'N/A';

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(100, 3, 169, 244),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/icon.png'),
              width: 40,
              height: 40,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Text Detector MLKIT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            )
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.privacy_tip, color: Colors.blue),
                  title: Text('Privacy policy'),
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.pushNamed(context, '/privacy');
                    });
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text('Support'),
                  onTap: () async {
                    Navigator.pop(context);
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'davigomesflorencio@gmail.com',
                      queryParameters: {
                        'subject': 'Solicitação de suporte',
                        'body': 'Por favor descreva sua solicitação:\n\n',
                      },
                    );

                    if (await launchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Não foi possível iniciar o cliente de e-mail')),
                      );
                    }
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.star, color: Colors.amber),
                  title: Text('Rate the app'),
                  onTap: () {
                    Navigator.pop(context);
                    _rateApp(context);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.info, color: Colors.green),
                  title: Text('About'),
                  onTap: () {
                    Future.delayed(Duration(milliseconds: 200), () {
                      Navigator.pushNamed(context, '/about');
                    });
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.code, color: Colors.grey),
                  title: Text('Version'),
                  subtitle: Text(_version),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to privacy policy
                  },
                ),
              ),
            ],
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: widget.text ?? ""));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Copiado!')),
          );
        },
        backgroundColor: Color.fromARGB(100, 3, 169, 244),
        child: Icon(
          Icons.copy,
          color: Colors.white,
        ),
      ),
      body: _galleryBody(),
    );
  }

  Widget _galleryBody() {
    return ListView(
      shrinkWrap: true,
      children: [
        _image != null
            ? Container(
                padding: EdgeInsets.all(32),
                child: SizedBox(
                  height: 400,
                  width: 400,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.file(_image!),
                    ],
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.all(32),
                child: Image(
                  image: AssetImage('assets/icon.png'),
                  width: 200,
                  height: 200,
                ),
              ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(100, 3, 169, 244),
            ),
            child: Text(
              'Select from gallery',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => _getImage(ImageSource.gallery),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(100, 3, 169, 244),
            ),
            child: Text(
              'Take a picture',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () => _getImage(ImageSource.camera),
          ),
        ),
        if (_isProcessing)
          SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(100, 3, 169, 244),
                backgroundColor: Color.fromARGB(100, 212, 211, 255),
                strokeWidth: 6,
              ),
            ),
          ),
        if (_image != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Divider(
                  color: Color.fromARGB(100, 3, 169, 244),
                ),
                Text(
                  _path == null ? '' : 'File Path:',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Divider(
                  color: Color.fromARGB(100, 3, 169, 244),
                ),
                Text(_path == null ? '' : '$_path'),
                Divider(
                  color: Color.fromARGB(100, 3, 169, 244),
                ),
                Text(
                  "Recognized text",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Divider(
                  color: Color.fromARGB(100, 3, 169, 244),
                ),
                Text(_path == null ? '' : widget.text ?? ''),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _getImage(ImageSource source) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _image = null;
      _path = null;
    });

    try {
      final pickedFile = await _imagePicker?.pickImage(source: source);

      if (pickedFile != null) {
        await _processFile(pickedFile.path);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhuma imagem selecionada.')),
          );
        }
      }
    } on PlatformException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao obter imagem: ${e.message}')),
        );
      }
      print('PlatformException ao obter imagem: ${e.toString()}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ocorreu um erro: ${e.toString()}')),
        );
      }
      print('Erro ao obter imagem: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _processFile(String path) async {
    if (!mounted) return;

    setState(() {
      _image = File(path);
      _path = path;
    });

    try {
      final inputImage = InputImage.fromFilePath(path);
      await widget.onImage(inputImage);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao processar imagem: ${e.toString()}')),
        );
      }
      print('Erro ao processar arquivo: ${e.toString()}');
    }
  }

  Future<void> _rateApp(BuildContext context) async {
    const packageName = 'com.davi.dev.text_detector_google_ml_kit';

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        await StoreRedirect.redirect(
          androidAppId: packageName,
        );
      }
    } catch (e) {
      // Fallback to web browser if app store fails
      final webUrl = Uri.parse(Theme.of(context).platform == TargetPlatform.android
          ? 'https://play.google.com/store/apps/details?id=$packageName'
          : 'https://apps.apple.com/app/idYOUR_APP_ID');

      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível iniciar a loja de aplicativos')),
        );
      }
    }
  }
}
