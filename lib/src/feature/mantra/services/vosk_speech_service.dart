import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

typedef PartialCallback = void Function(String text);
typedef VoidCallback = void Function();
typedef ErrorCallback = void Function(String error);

class VoskSpeechService {
  static const MethodChannel _channel = MethodChannel('vosk_speech_channel');
  
  bool _isInitialized = false;
  bool _isListening = false;
  PartialCallback? _onPartial;
  VoidCallback? _onComplete;
  ErrorCallback? _onError;

  /// Initialize the Vosk speech service
  /// Returns true if initialization was successful
  Future<bool> initialize({
    ErrorCallback? onError,
  }) async {
    if (_isInitialized) return true;

    _onError = onError;

    try {
      print('VoskSpeechService: Starting initialization...');
      
      // Check and request microphone permission
      final permissionStatus = await _requestMicrophonePermission();
      if (!permissionStatus) {
        print('VoskSpeechService: Microphone permission denied');
        _onError?.call('Microphone permission denied');
        return false;
      }
      
      print('VoskSpeechService: Microphone permission granted');

      // Initialize the native Vosk implementation
      print('VoskSpeechService: Calling native initialize...');
      final result = await _channel.invokeMethod<bool>('initialize') ?? false;
      _isInitialized = result;
      
      if (!result) {
        print('VoskSpeechService: Native initialization failed');
        _onError?.call('Failed to initialize Vosk');
      } else {
        print('VoskSpeechService: Initialization successful');
      }
      
      return result;
    } catch (e) {
      print('VoskSpeechService: Initialization error: $e');
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
      print('VoskSpeechService: Service not initialized');
      onError?.call('Service not initialized');
      return;
    }

    if (_isListening) {
      print('VoskSpeechService: Already listening, stopping first...');
      await stop();
    }

    _onPartial = onPartial;
    _onComplete = onComplete;
    _onError = onError;

    try {
      print('VoskSpeechService: Starting listening...');
      _isListening = true;
      
      // Set up method call handler for receiving results
      _channel.setMethodCallHandler(_handleMethodCall);
      
      // Start listening
      await _channel.invokeMethod('startListening');
      print('VoskSpeechService: Listening started successfully');
    } catch (e) {
      print('VoskSpeechService: Failed to start listening: $e');
      _isListening = false;
      _onError?.call('Failed to start listening: $e');
    }
  }

  /// Stop listening for speech
  Future<void> stop() async {
    if (!_isListening) return;

    try {
      await _channel.invokeMethod('stopListening');
      _isListening = false;
      _onComplete?.call();
    } catch (e) {
      _onError?.call('Failed to stop listening: $e');
    }
  }

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

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

  /// Handle method calls from the native side
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPartialResult':
        final text = call.arguments['text'] as String? ?? '';
        print('VoskSpeechService: Partial result: $text');
        if (text.isNotEmpty) {
          _onPartial?.call(text);
        }
        break;
        
      case 'onFinalResult':
        final text = call.arguments['text'] as String? ?? '';
        print('VoskSpeechService: Final result: $text');
        if (text.isNotEmpty) {
          _onPartial?.call(text);
        }
        _onComplete?.call();
        break;
        
      case 'onError':
        final error = call.arguments['error'] as String? ?? 'Unknown error';
        print('VoskSpeechService: Error from native: $error');
        _onError?.call(error);
        break;
        
      default:
        print('VoskSpeechService: Unknown method call: ${call.method}');
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
