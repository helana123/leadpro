import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class OCRService {
  Future<String> extractTextFromImage(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textDetector.processImage(inputImage);

    // Concatenate all the recognized text into a single string
    final StringBuffer buffer = StringBuffer();
    for (TextBlock block in recognizedText.blocks) {
      buffer.writeln(block.text);
    }

    textDetector.close();
    return buffer.toString();
  }

  void dispose() {
    // Dispose of any resources used by the OCR service
  }
}
