import Cocoa
import FlutterMacOS
import CPUInfo

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    
    let cpuChannel = FlutterMethodChannel(
      name: "com.tahatesser.anqa/cpuInfo",
      binaryMessenger: flutterViewController.engine.binaryMessenger)
    
    cpuChannel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "getCPUBrand":
        guard let cpuBrand = getCPUBrand() else {
          result(
            FlutterError(
              code: "UNAVAILABLE", message: "Brand not available", details: nil))
          return
        }
        result(cpuBrand)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    RegisterGeneratedPlugins(registry: flutterViewController)
    
    super.awakeFromNib()
  }
}

private func getCPUBrand() -> String? {
  return CPUInfo.brand?.description
}
