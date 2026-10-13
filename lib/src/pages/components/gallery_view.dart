// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class GalleryView extends StatefulWidget {
  const GalleryView(
      {Key? key,
      required this.title,
      this.text,
      required this.onImage,
      required this.onDetectorViewModeChanged})
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
  int? _fileSize;
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
                        SnackBar(
                            content: Text(
                                'Não foi possível iniciar o cliente de e-mail')),
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
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _galleryChildren(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _galleryChildren() {
    return [
      if (_image == null)
        Padding(
          padding: EdgeInsets.fromLTRB(32, 16, 32, 0),
          child: Text(
            'Recognize text from images using your gallery or camera',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
        child: Row(
          children: [
            Expanded(
              child: Tooltip(
                message: 'Select an image from the gallery',
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(100, 3, 169, 244),
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.photo_library),
                  label: Text('Gallery'),
                  onPressed: () => _getImage(ImageSource.gallery),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Tooltip(
                message: 'Take a picture with the camera',
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(100, 3, 169, 244),
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(Icons.camera_alt),
                  label: Text('Camera'),
                  onPressed: () => _getImage(ImageSource.camera),
                ),
              ),
            ),
          ],
        ),
      ),
      if (_isProcessing)
        Container(
          height: 50,
          width: 50,
          margin: EdgeInsets.only(top: 16),
          child: Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(100, 3, 169, 244),
              backgroundColor: Color.fromARGB(100, 212, 211, 255),
              strokeWidth: 6,
            ),
          ),
        ),
      if (_image != null && !_isProcessing) _resultCard(),
    ];
  }

  static const _accentColor = Color.fromARGB(255, 3, 169, 244);

  Widget _resultCard() {
    final text = (widget.text ?? '').trim();
    final hasText = text.isNotEmpty;
    final words = hasText ? text.split(RegExp(r'\s+')).length : 0;
    final lines =
        hasText ? text.split('\n').where((l) => l.trim().isNotEmpty).length : 0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: _accentColor.withValues(alpha: 0.1),
              padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Icon(Icons.text_snippet, color: _accentColor),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Recognized text',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy text',
                    icon: Icon(Icons.copy, color: _accentColor),
                    onPressed: hasText
                        ? () {
                            Clipboard.setData(ClipboardData(text: text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Copiado!')),
                            );
                          }
                        : null,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statChip(Icons.short_text, '$words words'),
                      _statChip(Icons.format_list_numbered, '$lines lines'),
                      _statChip(Icons.abc, '${text.length} chars'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: hasText
                        ? SelectableText(text,
                            style: TextStyle(fontSize: 15, height: 1.4))
                        : Text(
                            'No text detected in this image.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                  ),
                  SizedBox(height: 16),
                  Divider(height: 1),
                  SizedBox(height: 12),
                  Text(
                    'File information',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  _infoRow(Icons.image, 'Name', p.basename(_path!)),
                  _infoRow(
                      Icons.sd_storage, 'Size', _formatBytes(_fileSize ?? 0)),
                  _infoRow(Icons.folder, 'Path', _path!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: _accentColor),
      label: Text(label),
      backgroundColor: _accentColor.withValues(alpha: 0.08),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          SizedBox(width: 8),
          SizedBox(
            width: 48,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _getImage(ImageSource source) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _image = null;
      _path = null;
      _fileSize = null;
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
      _fileSize = File(path).lengthSync();
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
      final webUrl = Uri.parse(
          Theme.of(context).platform == TargetPlatform.android
              ? 'https://play.google.com/store/apps/details?id=$packageName'
              : 'https://apps.apple.com/app/idYOUR_APP_ID');

      if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Não foi possível iniciar a loja de aplicativos')),
        );
      }
    }
  }
}
