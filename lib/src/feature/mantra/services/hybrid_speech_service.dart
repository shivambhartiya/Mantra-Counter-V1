import 'dart:async';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

typedef PartialCallback = void Function(String text);
typedef VoidCallback = void Function();
typedef ErrorCallback = void Function(String error);

class HybridSpeechService {
  static const MethodChannel _channel = MethodChannel('vosk_speech_channel');
  
  final stt.SpeechToText _fallbackSpeech = stt.SpeechToText();
  
  bool _isInitialized = false;
  bool _isListening = false;
  bool _useVosk = true;
  PartialCallback? _onPartial;
  VoidCallback? _onComplete;
  ErrorCallback? _onError;

  /// Initialize the speech service
  /// Tries Vosk first, falls back to speech_to_text if Vosk fails
  Future<bool> initialize({
    ErrorCallback? onError,
  }) async {
    if (_isInitialized) return true;

    _onError = onError;

    try {
      print('HybridSpeechService: Starting initialization...');
      
      // Check and request microphone permission
      final permissionStatus = await _requestMicrophonePermission();
      if (!permissionStatus) {
        print('HybridSpeechService: Microphone permission denied');
        _onError?.call('Microphone permission denied');
        return false;
      }
      
      print('HybridSpeechService: Microphone permission granted');

      // Try Vosk first
      if (_useVosk) {
        try {
          print('HybridSpeechService: Trying Vosk initialization...');
          final voskResult = await _channel.invokeMethod<bool>('initialize') ?? false;
          if (voskResult) {
            print('HybridSpeechService: Vosk initialization successful');
            _isInitialized = true;
            return true;
          } else {
            print('HybridSpeechService: Vosk initialization failed, falling back to speech_to_text');
            _useVosk = false;
          }
        } catch (e) {
          print('HybridSpeechService: Vosk error: $e, falling back to speech_to_text');
          _useVosk = false;
        }
      }

      // Fallback to speech_to_text
      if (!_useVosk) {
        print('HybridSpeechService: Initializing speech_to_text fallback...');
        final fallbackResult = await _fallbackSpeech.initialize(
          onError: (err) {
            print('HybridSpeechService: speech_to_text error: $err');
            _onError?.call(err.errorMsg);
          },
          onStatus: (status) {
            print('HybridSpeechService: speech_to_text status: $status');
          },
        );
        
        if (fallbackResult) {
          print('HybridSpeechService: speech_to_text initialization successful');
          _isInitialized = true;
          return true;
        }
      }

      print('HybridSpeechService: All initialization methods failed');
      _onError?.call('Failed to initialize speech recognition');
      return false;
    } catch (e) {
      print('HybridSpeechService: Initialization error: $e');
      _onError?.call('Initialization error: $e');
      return false;
    }
  }

  /// Start listening for speech
  Future<void> start({
    required PartialCallback onPartial,
    VoidCallback? onComplete,
    ErrorCallback? onError,
  }) async {
    if (!_isInitialized) {
      print('HybridSpeechService: Service not initialized');
      onError?.call('Service not initialized');
      return;
    }

    if (_isListening) {
      print('HybridSpeechService: Already listening, stopping first...');
      await stop();
    }

    _onPartial = onPartial;
    _onComplete = onComplete;
    _onError = onError;

    try {
      print('HybridSpeechService: Starting listening with ${_useVosk ? 'Vosk' : 'speech_to_text'}...');
      _isListening = true;
      
      if (_useVosk) {
        // Use Vosk
        _channel.setMethodCallHandler(_handleVoskMethodCall);
        await _channel.invokeMethod('startListening');
        print('HybridSpeechService: Vosk listening started');
      } else {
        // Use speech_to_text fallback
        await _fallbackSpeech.listen(
          onResult: (result) {
            final text = result.recognizedWords;
            if (text.isNotEmpty) {
              print('HybridSpeechService: speech_to_text result: $text');
              _onPartial?.call(text);
            }
            if (result.finalResult) {
              _onComplete?.call();
            }
          },
          listenMode: stt.ListenMode.confirmation,
          partialResults: true,
          cancelOnError: true,
        );
        print('HybridSpeechService: speech_to_text listening started');
      }
    } catch (e) {
      print('HybridSpeechService: Failed to start listening: $e');
      _isListening = false;
      _onError?.call('Failed to start listening: $e');
    }
  }

  /// Stop listening for speech
  Future<void> stop() async {
    if (!_isListening) return;

    try {
      if (_useVosk) {
        await _channel.invokeMethod('stopListening');
      } else {
        await _fallbackSpeech.stop();
      }
      _isListening = false;
      _onComplete?.call();
      print('HybridSpeechService: Listening stopped');
    } catch (e) {
      print('HybridSpeechService: Error stopping listening: $e');
      _onError?.call('Failed to stop listening: $e');
    }
  }

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Check if using Vosk
  bool get isUsingVosk => _useVosk;

  /// Request microphone permission
  Future<bool> _requestMicrophonePermission() async {
    final status = await Permission.microphone.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }
    
    return false;
  }

  /// Handle method calls from Vosk native side
  Future<dynamic> _handleVoskMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPartialResult':
        final text = call.arguments['text'] as String? ?? '';
        print('HybridSpeechService: Vosk partial result: $text');
        if (text.isNotEmpty) {
          _onPartial?.call(text);
        }
        break;
        
      case 'onFinalResult':
        final text = call.arguments['text'] as String? ?? '';
        print('HybridSpeechService: Vosk final result: $text');
        if (text.isNotEmpty) {
          _onPartial?.call(text);
        }
        _onComplete?.call();
        break;
        
      case 'onError':
        final error = call.arguments['error'] as String? ?? 'Unknown error';
        print('HybridSpeechService: Vosk error: $error');
        _onError?.call(error);
        break;
        
      default:
        print('HybridSpeechService: Unknown Vosk method call: ${call.method}');
        break;
    }
  }

  /// Dispose resources
  void dispose() {
    if (_isListening) {
      stop();
    }
    _channel.setMethodCallHandler(null);
    _isInitialized = false;
  }
}
