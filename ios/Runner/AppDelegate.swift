import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    var uiController: UIDocumentInteractionController?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController

        let viewPdfFileChannel = FlutterMethodChannel(name: "launchFile",
                                                       binaryMessenger: controller.binaryMessenger)

        viewPdfFileChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }

            if call.method == "viewPdf" || call.method == "viewExcel" {
                guard let args = call.arguments as? [String: Any],
                      let filePath = args["file_path"] as? String else {
                    result(FlutterError(code: "INVALID_ARGUMENT", 
                                        message: "File path is required", 
                                        details: nil))
                    return
                }

                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    let fileExtension = (filePath as NSString).pathExtension
                    self.uiController = UIDocumentInteractionController(url: URL(fileURLWithPath: filePath))
                    self.uiController?.delegate = self

                    switch fileExtension {
                    case "pdf":
                        self.uiController?.uti = "com.adobe.pdf"
                    case "xlsx":
                        self.uiController?.uti = "com.microsoft.excel.xls"
                    case "txt":
                        self.uiController?.uti = "public.plain-text"
                    default:
                        print("The format \(filePath) is not supported")
                    }

                    do {
                        if !(self.uiController?.presentPreview(animated: true) ?? false) {
                            self.uiController?.presentOpenInMenu(from: CGRect(x: 200, y: 20, width: 100, height: 100),
                                                                  in: controller.view,
                                                                  animated: true)
                        }
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

extension AppDelegate: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
}
