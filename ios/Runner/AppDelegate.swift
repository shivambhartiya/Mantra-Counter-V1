import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let voskChannel = FlutterMethodChannel(name: "vosk_speech_channel", binaryMessenger: controller.binaryMessenger)
    
    if #available(iOS 13.0, *) {
      let voskHandler = VoskMethodCallHandler(channel: voskChannel)
      voskChannel.setMethodCallHandler(voskHandler.handle(_:result:))
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
