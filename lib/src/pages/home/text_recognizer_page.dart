import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:text_detector_google_ml_kit/painters/text_detector_painter.dart';
import 'package:text_detector_google_ml_kit/src/pages/components/detector_view.dart';

class TextRecognizerPage extends StatefulWidget {
  const TextRecognizerPage({Key? key}) : super(key: key);

  @override
  State<TextRecognizerPage> createState() => _TextRecognizerPageState();
}

class _TextRecognizerPageState extends State<TextRecognizerPage> {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Reconhecimento de textos',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage2,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage2(InputImage inputImage) async {
    try {
      // Verificações iniciais
      if (!_canProcess || _isBusy) return;

      _isBusy = true;
      if (mounted) {
        setState(() {
          _text = '';
        });
      }

      // Processamento do texto
      final recognizedText = await _textRecognizer.processImage(inputImage);
      // .timeout(const Duration(seconds: 10), onTimeout: () {
      //   throw TimeoutException('Tempo limite excedido no processamento de texto');
      // });

      // Atualização da UI com os resultados
      if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
        final painter = TextRecognizerPainter(
          recognizedText,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
        );
        _customPaint = CustomPaint(painter: painter);
      } else {
        _text = 'Texto reconhecido:\n\n${recognizedText.text}';
        _customPaint = null;
      }
      _isBusy = false;
      if (mounted) {
        setState(() {});
      }
    } on PlatformException catch (e) {
      _handleError('Erro na plataforma: ${e.message}');
    } on TimeoutException catch (e) {
      _handleError(e.message ?? 'Tempo limite excedido');
    } on Exception catch (e) {
      _handleError('Erro no processamento: ${e.toString()}');
    }
  }

  void _handleError(String message) {
    if (!mounted) return;

    setState(() {
      _text = 'Falha ao processar imagem';
      _customPaint = null;
    });

    // Opcional: Log para debug
    debugPrint('Erro no processamento de imagem: $message');
  }
}
