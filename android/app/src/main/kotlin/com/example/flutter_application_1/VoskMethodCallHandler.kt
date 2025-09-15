package com.example.flutter_application_1

import android.content.Context
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import org.vosk.LibVosk
import org.vosk.LogLevel
import org.vosk.Model
import org.vosk.Recognizer
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.nio.ByteBuffer
import java.nio.ByteOrder

class VoskMethodCallHandler(private val context: Context) : MethodChannel.MethodCallHandler {
    private var model: Model? = null
    private var recognizer: Recognizer? = null
    private var audioRecord: AudioRecord? = null
    private var isListening = false
    private var methodChannel: MethodChannel? = null
    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    
    companion object {
        private const val TAG = "VoskMethodCallHandler"
        private const val SAMPLE_RATE = 16000
        private const val CHANNEL_CONFIG = AudioFormat.CHANNEL_IN_MONO
        private const val AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> initialize(result)
            "startListening" -> startListening(result)
            "stopListening" -> stopListening(result)
            else -> result.notImplemented()
        }
    }

    private fun initialize(result: MethodChannel.Result) {
        try {
            scope.launch {
                try {
                    Log.d(TAG, "Starting Vosk initialization...")
                    
                    // Initialize Vosk library
                    LibVosk.setLogLevel(LogLevel.WARNINGS)
                    Log.d(TAG, "Vosk library initialized")
                    
                    // Load model from assets
                    Log.d(TAG, "Copying model from assets...")
                    val modelPath = copyModelFromAssets()
                    if (modelPath == null) {
                        Log.e(TAG, "Failed to copy model from assets")
                        withContext(Dispatchers.Main) {
                            result.success(false)
                        }
                        return@launch
                    }
                    
                    Log.d(TAG, "Model copied to: $modelPath")
                    
                    // Verify model directory exists and has required files
                    val modelDir = File(modelPath)
                    if (!modelDir.exists()) {
                        Log.e(TAG, "Model directory does not exist: $modelPath")
                        withContext(Dispatchers.Main) {
                            result.success(false)
                        }
                        return@launch
                    }
                    
                    val requiredFiles = listOf("am/final.mdl", "graph/phones.txt", "graph/words.txt")
                    for (requiredFile in requiredFiles) {
                        val file = File(modelDir, requiredFile)
                        if (!file.exists()) {
                            Log.e(TAG, "Required model file missing: $requiredFile")
                            withContext(Dispatchers.Main) {
                                result.success(false)
                            }
                            return@launch
                        }
                    }
                    
                    Log.d(TAG, "Loading Vosk model...")
                    model = Model(modelPath)
                    recognizer = Recognizer(model, SAMPLE_RATE.toFloat())
                    
                    Log.d(TAG, "Vosk initialization successful")
                    withContext(Dispatchers.Main) {
                        result.success(true)
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to initialize Vosk", e)
                    withContext(Dispatchers.Main) {
                        result.success(false)
                    }
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in initialize", e)
            result.success(false)
        }
    }

    private fun startListening(result: MethodChannel.Result) {
        if (isListening) {
            result.success(true)
            return
        }

        if (recognizer == null) {
            Log.e(TAG, "Recognizer not initialized")
            result.success(false)
            return
        }

        try {
            Log.d(TAG, "Starting audio recording...")
            
            val bufferSize = AudioRecord.getMinBufferSize(
                SAMPLE_RATE, CHANNEL_CONFIG, AUDIO_FORMAT
            ) * 2

            Log.d(TAG, "Audio buffer size: $bufferSize")

            audioRecord = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                SAMPLE_RATE,
                CHANNEL_CONFIG,
                AUDIO_FORMAT,
                bufferSize
            )

            if (audioRecord?.state != AudioRecord.STATE_INITIALIZED) {
                Log.e(TAG, "AudioRecord initialization failed. State: ${audioRecord?.state}")
                result.success(false)
                return
            }

            Log.d(TAG, "AudioRecord initialized successfully")
            
            isListening = true
            audioRecord?.startRecording()
            Log.d(TAG, "Audio recording started")
            
            result.success(true)

            scope.launch {
                val buffer = ByteArray(bufferSize)
                while (isListening && audioRecord != null) {
                    val bytesRead = audioRecord?.read(buffer, 0, buffer.size) ?: 0
                    if (bytesRead > 0) {
                        processAudioData(buffer, bytesRead)
                    }
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error starting listening", e)
            result.success(false)
        }
    }

    private fun stopListening(result: MethodChannel.Result) {
        try {
            isListening = false
            audioRecord?.stop()
            audioRecord?.release()
            audioRecord = null
            
            // Get final result
            recognizer?.let { rec ->
                val finalResult = rec.finalResult
                methodChannel?.invokeMethod("onFinalResult", mapOf("text" to extractText(finalResult)))
                rec.reset()
            }
            
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping listening", e)
            result.success(false)
        }
    }

    private fun processAudioData(buffer: ByteArray, bytesRead: Int) {
        try {
            recognizer?.let { rec ->
                val audioData = ByteBuffer.wrap(buffer, 0, bytesRead)
                    .order(ByteOrder.LITTLE_ENDIAN)
                    .asShortBuffer()
                    .array()

                val byteArray = ByteArray(audioData.size * 2)
                var index = 0
                for (sample in audioData) {
                    byteArray[index++] = (sample.toInt() and 0xFF).toByte()
                    byteArray[index++] = ((sample.toInt() shr 8) and 0xFF).toByte()
                }

                if (rec.acceptWaveform(byteArray, byteArray.size)) {
                    val result = rec.result
                    val text = extractText(result)
                    Log.d(TAG, "Final result: $text")
                    if (text.isNotEmpty()) {
                        methodChannel?.invokeMethod("onPartialResult", mapOf("text" to text))
                    }
                } else {
                    val partialResult = rec.partialResult
                    val text = extractText(partialResult)
                    if (text.isNotEmpty()) {
                        Log.d(TAG, "Partial result: $text")
                        methodChannel?.invokeMethod("onPartialResult", mapOf("text" to text))
                    }
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error processing audio data", e)
            methodChannel?.invokeMethod("onError", mapOf("error" to e.message))
        }
    }

    private fun extractText(jsonResult: String): String {
        return try {
            val jsonObject = org.json.JSONObject(jsonResult)
            jsonObject.optString("text", "")
        } catch (e: Exception) {
            ""
        }
    }

    private fun copyModelFromAssets(): String? {
        return try {
            val modelDir = File(context.filesDir, "vosk_model")
            if (!modelDir.exists()) {
                modelDir.mkdirs()
                
                // Copy model files from assets recursively
                copyAssetsRecursively("vosk_model", modelDir)
            }
            modelDir.absolutePath
        } catch (e: Exception) {
            Log.e(TAG, "Failed to copy model from assets", e)
            null
        }
    }

    private fun copyAssetsRecursively(assetPath: String, targetDir: File) {
        val assetManager = context.assets
        val files = assetManager.list(assetPath)
        
        files?.forEach { fileName ->
            val assetFilePath = if (assetPath.isEmpty()) fileName else "$assetPath/$fileName"
            val targetFile = File(targetDir, fileName)
            
            try {
                val inputStream = assetManager.open(assetFilePath)
                if (inputStream.available() > 0) {
                    // It's a file
                    targetFile.parentFile?.mkdirs()
                    targetFile.outputStream().use { output ->
                        inputStream.copyTo(output)
                    }
                    Log.d(TAG, "Copied file: $assetFilePath -> ${targetFile.absolutePath}")
                } else {
                    // It's a directory
                    targetFile.mkdirs()
                    copyAssetsRecursively(assetFilePath, targetFile)
                    Log.d(TAG, "Copied directory: $assetFilePath -> ${targetFile.absolutePath}")
                }
                inputStream.close()
            } catch (e: Exception) {
                Log.e(TAG, "Error copying $assetFilePath", e)
            }
        }
    }

    fun setMethodChannel(channel: MethodChannel) {
        this.methodChannel = channel
    }

    fun dispose() {
        scope.cancel()
        isListening = false
        audioRecord?.release()
        audioRecord = null
        recognizer = null
        model = null
    }
}
