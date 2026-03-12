import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "family_helper/notification_permissions",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, result in
        switch call.method {
        case "getNotificationPermissionStatus":
          self?.getNotificationPermissionStatus(result: result)
        case "openNotificationSettings":
          result(self?.openNotificationSettings() ?? false)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getNotificationPermissionStatus(result: @escaping FlutterResult) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      let status: String
      switch settings.authorizationStatus {
      case .authorized, .provisional, .ephemeral:
        status = "granted"
      case .denied:
        status = "denied"
      case .notDetermined:
        status = "notDetermined"
      @unknown default:
        status = "notDetermined"
      }
      result(status)
    }
  }

  private func openNotificationSettings() -> Bool {
    guard let url = URL(string: UIApplication.openSettingsURLString) else {
      return false
    }
    DispatchQueue.main.async {
      UIApplication.shared.open(url)
    }
    return true
  }
}
