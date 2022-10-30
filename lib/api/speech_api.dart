// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart';

//Mikail imza - 30.10.20.22 ---- mikailimza@gmail.com 
class SpeechApi {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording({
    required Function(String text) onResult,
    required ValueChanged<bool> onListening,
  }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) => onListening(_speech.isListening),
      onError: (e) => print('Error: $e'),
    );

    if (isAvailable) {
      _speech.listen(onResult: (value) => onResult(value.recognizedWords));
    }

    return isAvailable;
  }

  static Future<bool> toogleSpeechText() async {

    
    return true;
  }
}
