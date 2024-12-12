import Cocoa
import FlutterMacOS

public class DesktopWindowPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "desktop_window", binaryMessenger: registrar.messenger)
    let instance = DesktopWindowPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        
    case "getWindowSize":
        if let window = NSApplication.shared.mainWindow {
            let width = window.frame.size.width;
            let height = window.frame.size.height;
            result([width, height])
        } else {
            result("mainWindow not found") // should return error or throw exception here.
        }
            
    case "setWindowSize":
        if let window = NSApplication.shared.mainWindow {
            if let width: Float = (call.arguments as? [String: Any])?["width"] as? Float,
                let height: Float = (call.arguments as? [String: Any])?["height"] as? Float
                {
                    var rect = window.frame;
                    rect.origin.y += (rect.size.height - CGFloat(height));
                    rect.size.width = CGFloat(width);
                    rect.size.height = CGFloat(height);

                    window.setFrame(rect, display: true)
                
            }

            result(true)
        } else {
            result("mainWindow not found") // should return error or throw exception here.
        }
        
    case "setMinWindowSize":
        if let window = NSApplication.shared.mainWindow {
            if let width: Float = (call.arguments as? [String: Any])?["width"] as? Float,
                let height: Float = (call.arguments as? [String: Any])?["height"] as? Float
                {
                    window.minSize = CGSize(width:CGFloat(width),height:CGFloat(height));
                
            }

            result(true)
        } else {
            result("mainWindow not found") // should return error or throw exception here.
        }
        
    case "setMaxWindowSize":
        if let window = NSApplication.shared.mainWindow {
            if let width: Float = (call.arguments as? [String: Any])?["width"] as? Float,
                let height: Float = (call.arguments as? [String: Any])?["height"] as? Float
                {
                    if (width == 0 || height == 0) {
                        window.maxSize = CGSize(width:CGFloat(Float.greatestFiniteMagnitude), height:CGFloat(Float.greatestFiniteMagnitude))
                    } else {
                        window.maxSize = CGSize(width:CGFloat(width), height:CGFloat(height));
                    }

            }
            result(true)
        } else {
            result("mainWindow not found") // should return error or throw exception here.
        }
        
    case "resetMaxWindowSize":
        if let window = NSApplication.shared.mainWindow {
            window.maxSize = CGSize(width:CGFloat(Float.greatestFiniteMagnitude), height:CGFloat(Float.greatestFiniteMagnitude))
            result(true)
        } else {
            result("mainWindow not found") // should return error or throw exception here.
        }

    case "toggleFullScreen":
        if let window = NSApplication.shared.mainWindow {
            window.toggleFullScreen(nil);
            result(true)
        } else {
            result("mainWindow not found") // should return error or throw exception here.
        }
    case "setFullScreen":
        if let bFullScreen: Bool = (call.arguments as? [String: Any])?["fullscreen"] as? Bool {

            if let window = NSApplication.shared.mainWindow {
                if (bFullScreen) {
                    if (!window.styleMask.contains(.fullScreen)) {
                        window.toggleFullScreen(nil);
                    }
                } else {
                    if (window.styleMask.contains(.fullScreen)) {
                        window.toggleFullScreen(nil);
                    }
                }
                result(true)
            } else {
                result("mainWindow not found") // should return error or throw exception here.
            }
        }
    case "getFullScreen":
        if let window = NSApplication.shared.mainWindow {
            if (window.styleMask.contains(.fullScreen)) {
                result(true)
            } else {
                result(false)
            }
        } else {
            result("mainWindow not found") // should return error or throw exception here.
        }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
