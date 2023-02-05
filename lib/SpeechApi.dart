import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechApi {
  static final _speech = SpeechToText();
  // static bool _isListening = false;
  // static String _text = 'Press the button and start speaking';
  // static double _confidence = 1.0;

  static Future<bool> toggleRecording({
    required Function(String) onResult,
  }) async {
    final _isAvailable = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (_isAvailable) {
      // setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) => onResult(val.recognizedWords),
      );
    }
    return _isAvailable;
  }
}
