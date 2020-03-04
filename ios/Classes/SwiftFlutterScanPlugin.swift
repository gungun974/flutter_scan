import Flutter
import UIKit
import WeScan

class HomeViewController: UIViewController, ImageScannerControllerDelegate {    

    var _result:FlutterResult?   

    override func viewDidAppear(_ animated: Bool) {       
        if self.isBeingPresented {
          let scannerViewController = ImageScannerController()
          scannerViewController.imageScannerDelegate = self
          scannerViewController.modalPresentationStyle = .fullScreen;
          present(scannerViewController, animated: true)
        }
    }  

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
    // You are responsible for carefully handling the error
    print(error)
    _result!(nil)
    }

    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        // The user successfully scanned an image, which is available in the ImageScannerResults
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
        _result!(saveToFile(image: results.croppedScan.image))
        self.dismiss(animated: true)  
    }

    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // The user tapped 'Cancel' on the scanner
        // You are responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
         _result!(nil)
        self.dismiss(animated: true)
    }
    

    private func saveToFile(image: UIImage) -> Any {
      guard let data = image.jpegData(compressionQuality: 1.0) else {
      return FlutterError(code: "image_encoding_error", message: "Could not read image", details: nil)
    }
    let tempDir = NSTemporaryDirectory()
    let imageName = "image_picker_\(ProcessInfo().globallyUniqueString).jpg"
    let filePath = tempDir.appending(imageName)
    if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil) {
      return filePath
    } else {
      return FlutterError(code: "image_save_failed", message: "Could not save image to disk", details: nil)
    }
  }
}


public class SwiftFlutterScanPlugin: NSObject, FlutterPlugin, UIApplicationDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "fr.gungun974/flutter_scan", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterScanPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }


  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    if let viewController = UIApplication.shared.delegate?.window??.rootViewController as? FlutterViewController {
        let destinationViewController = HomeViewController()
        destinationViewController.modalPresentationStyle = .fullScreen;
        destinationViewController._result = result
        viewController.present(destinationViewController,animated: true,completion: nil);
    }
  }
}
