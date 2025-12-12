import Cocoa
import FlutterMacOS

public class DesktopWindowPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "desktop_window", binaryMessenger: registrar.messenger)
    let instance = DesktopWindowPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let firstWindow = NSApplication.shared.windows.isEmpty ? nil : NSApplication.shared.windows[0]
    if let window = NSApplication.shared.mainWindow ?? firstWindow {
      switch call.method {

      case "getWindowSize":
        let width = window.frame.size.width
        let height = window.frame.size.height
        result([width, height])

      case "setWindowSize":
        if let width: Float = (call.arguments as? [String: Any])?["width"] as? Float,
          let height: Float = (call.arguments as? [String: Any])?["height"] as? Float,
          let animate: Bool = (call.arguments as? [String: Any])?["animate"] as? Bool
        {
          var rect = window.frame
          rect.origin.y += (rect.size.height - CGFloat(height))
          rect.size.width = CGFloat(width)
          rect.size.height = CGFloat(height)

          window.animator().setFrame(rect, display: true, animate: animate)

        }

        result(true)

      case "setMinWindowSize":
        if let width: Float = (call.arguments as? [String: Any])?["width"] as? Float,
          let height: Float = (call.arguments as? [String: Any])?["height"] as? Float
        {
          window.minSize = CGSize(width: CGFloat(width), height: CGFloat(height))

        }

        result(true)

      case "setMaxWindowSize":
        if let width: Float = (call.arguments as? [String: Any])?["width"] as? Float,
          let height: Float = (call.arguments as? [String: Any])?["height"] as? Float
        {
          if width == 0 || height == 0 {
            window.maxSize = CGSize(
              width: CGFloat(Float.greatestFiniteMagnitude),
              height: CGFloat(Float.greatestFiniteMagnitude))
          } else {
            window.maxSize = CGSize(width: CGFloat(width), height: CGFloat(height))
          }

        }
        result(true)

      case "resetMaxWindowSize":
        window.maxSize = CGSize(
          width: CGFloat(Float.greatestFiniteMagnitude),
          height: CGFloat(Float.greatestFiniteMagnitude))

        result(true)

      case "toggleFullScreen":
        window.toggleFullScreen(nil)
        result(true)

      case "setFullScreen":
        if let bFullScreen: Bool = (call.arguments as? [String: Any])?["fullscreen"] as? Bool {

          if bFullScreen {
            if !window.styleMask.contains(.fullScreen) {
              window.toggleFullScreen(nil)
            }
          } else {
            if window.styleMask.contains(.fullScreen) {
              window.toggleFullScreen(nil)
            }
          }
          result(true)
        }

      case "getFullScreen":
        result(window.styleMask.contains(.fullScreen))

      case "toggleBorders":
        if window.styleMask.contains(.borderless) {
          window.styleMask.remove(.borderless)
        } else {
          window.styleMask.insert(.borderless)
        }
        result(true)

      case "setBorders":
        if let bBorders: Bool = (call.arguments as? [String: Any])?["borders"] as? Bool {
          if window.styleMask.contains(.borderless) == bBorders {
            if bBorders {
              window.styleMask.remove(.borderless)
            } else {
              window.styleMask.insert(.borderless)
            }
          }
          result(true)
        }

      case "hasBorders":
        result(!window.styleMask.contains(.borderless))

      case "focus":
        NSApplication.shared.activate(ignoringOtherApps: true)
        result(true)

      case "stayOnTop":
        if let bstayOnTop: Bool = (call.arguments as? [String: Any])?["stayOnTop"] as? Bool {
          if bstayOnTop {
            window.level = .floating;
          } else {
            window.level = .normal;
          }
        }
        result(true)

      default:
        result(FlutterMethodNotImplemented)
      }
    } else {
      result("mainWindow not found")  // should return error or throw exception here.
    }
  }
}
