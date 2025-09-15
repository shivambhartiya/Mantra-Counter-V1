import 'package:speech_to_text/speech_to_text.dart' as stt;

typedef PartialCallback = void Function(String text);
typedef VoidCallback = void Function();

class SpeechService {
  SpeechService({stt.SpeechToText? speech}) : _speech = speech ?? stt.SpeechToText();

  final stt.SpeechToText _speech;

  Future<bool> initialize() async {
    return _speech.initialize(
      onError: (err) {},
      onStatus: (status) {},
    );
  }

  Future<void> start({required PartialCallback onPartial, VoidCallback? onComplete}) async {
    await _speech.listen(
      onResult: (res) {
        final text = res.recognizedWords;
        if (text.isNotEmpty) onPartial(text);
        if (res.finalResult) {
          onComplete?.call();
        }
      },
      listenMode: stt.ListenMode.confirmation,
      partialResults: true,
      cancelOnError: true,
    );
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}
