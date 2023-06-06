import UIKit
import Flutter
import ReveChatSDK
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let flutterVC = FlutterViewController()
    let navVC = UINavigationController(rootViewController: flutterVC)
    self.window?.rootViewController = navVC
    navVC.navigationBar.isHidden = true
    let batteryChannel = FlutterMethodChannel(name: "com.revechat.sdk/sdkchannel",
                                                binaryMessenger: flutterVC.binaryMessenger)

batteryChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          let reveChatManager = ReveChatManager()
          reveChatManager.setupAccount(with: "account_number") // put your account_number here
          
          switch call.method {
          case "StartREVEChat":
              print("success")
              
              guard let args = call.arguments as? [String:String] else {
                  print("failed fetching")
                  return
              }
              let name = args["name"]!
              let email = args["email"]!
              let phone = args["phone"]!
              
              reveChatManager.initiateReveChat(with: name,
                                               visitorEmail: email,
                                               visitorMobile: phone,
                                               onNavigationViewController: flutterVC.navigationController)
              break
          default:
              break
          }          
      })
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
