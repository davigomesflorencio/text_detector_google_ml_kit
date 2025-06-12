// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
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
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: widget.onDetectorViewModeChanged,
                child: Icon(
                  Platform.isIOS ? Icons.camera_alt_outlined : Icons.camera,
                  color: Colors.white,
                ),
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
        body: _galleryBody());
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      _image != null
          ? SizedBox(
              height: 400,
              width: 400,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(_image!),
                ],
              ),
            )
          : Icon(
              Icons.image,
              size: 200,
            ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(100, 3, 169, 244),
          ),
          child: Text(
            'Selecionar da galeria',
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
            'Tirar uma foto',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () => _getImage(ImageSource.camera),
        ),
      ),
      if (_isProcessing) CircularProgressIndicator(),
      if (_image != null)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${_path == null ? '' : 'Image path: $_path'}\n\n${widget.text ?? ''}'),
        ),
    ]);
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
}
