import Foundation
import Flutter
import AVFoundation
import Speech

@available(iOS 13.0, *)
class VoskMethodCallHandler: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel
    private var audioEngine: AVAudioEngine?
    private var inputNode: AVAudioInputNode?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognizer: SFSpeechRecognizer?
    private var isListening = false
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
        super.init()
    }
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "vosk_speech_channel", binaryMessenger: registrar.messenger())
        let instance = VoskMethodCallHandler(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            initialize(result: result)
        case "startListening":
            startListening(result: result)
        case "stopListening":
            stopListening(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initialize(result: @escaping FlutterResult) {
        // Request speech recognition authorization
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    // Request microphone permission
                    AVAudioSession.sharedInstance().requestRecordPermission { granted in
                        DispatchQueue.main.async {
                            if granted {
                                self.setupAudioEngine()
                                result(true)
                            } else {
                                result(false)
                            }
                        }
                    }
                case .denied, .restricted, .notDetermined:
                    result(false)
                @unknown default:
                    result(false)
                }
            }
        }
    }
    
    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine?.inputNode
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    }
    
    private func startListening(result: @escaping FlutterResult) {
        guard !isListening else {
            result(true)
            return
        }
        
        guard let audioEngine = audioEngine,
              let inputNode = inputNode,
              let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            result(false)
            return
        }
        
        do {
            // Create recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else {
                result(false)
                return
            }
            
            recognitionRequest.shouldReportPartialResults = true
            
            // Configure audio session
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // Start recognition task
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] recognitionResult, error in
                DispatchQueue.main.async {
                    if let recognitionResult = recognitionResult {
                        let text = recognitionResult.bestTranscription.formattedString
                        self?.channel.invokeMethod("onPartialResult", arguments: ["text": text])
                        
                        if recognitionResult.isFinal {
                            self?.channel.invokeMethod("onFinalResult", arguments: ["text": text])
                        }
                    }
                    
                    if let error = error {
                        self?.channel.invokeMethod("onError", arguments: ["error": error.localizedDescription])
                    }
                }
            }
            
            // Install tap on input node
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.recognitionRequest?.append(buffer)
            }
            
            // Start audio engine
            audioEngine.prepare()
            try audioEngine.start()
            
            isListening = true
            result(true)
            
        } catch {
            result(false)
        }
    }
    
    private func stopListening(result: @escaping FlutterResult) {
        guard isListening else {
            result(true)
            return
        }
        
        audioEngine?.stop()
        inputNode?.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        
        isListening = false
        result(true)
    }
    
    func dispose() {
        if isListening {
            stopListening { _ in }
        }
        audioEngine = nil
        inputNode = nil
        recognitionRequest = nil
        recognitionTask = nil
        speechRecognizer = nil
    }
}
