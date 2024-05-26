import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let googleMapsChannel = FlutterMethodChannel(name: "com.example.app/google_maps",
                                                  binaryMessenger: controller.binaryMessenger)
    
    googleMapsChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "provideApiKey" {
        if let args = call.arguments as? [String: Any], let apiKey = args["apiKey"] as? String {
          GMSServices.provideAPIKey(apiKey)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "API key not provided", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
