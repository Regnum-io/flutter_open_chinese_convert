import FlutterMacOS
import Foundation
import OpenCC

public class FlutterOpenChineseConvertPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "flutter_open_chinese_convert", binaryMessenger: registrar.messenger)
        registrar.addMethodCallDelegate(FlutterOpenChineseConvertPlugin(), channel: channel)
    }

    private func options(for id: String) -> ChineseConverter.Options? {
        switch id {
        case "s2t": return [.traditionalize]
        case "t2s": return [.simplify]
        case "s2hk": return [.traditionalize, .hkStandard]
        case "hk2s": return [.simplify, .hkStandard]
        case "s2tw": return [.traditionalize, .twStandard]
        case "tw2s": return [.simplify, .twStandard]
        case "s2twp": return [.traditionalize, .twStandard, .twIdiom]
        case "tw2sp": return [.simplify, .twStandard, .twIdiom]
        default: return nil
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard call.method == "convert" else {
            result(FlutterMethodNotImplemented)
            return
        }
        guard let arguments = call.arguments as? [Any], arguments.count >= 3,
            let text = arguments[0] as? String,
            let optionID = arguments[1] as? String,
            let inBackground = arguments[2] as? Bool
        else {
            result(
                FlutterError(
                    code: "MISSING_PARAMETER",
                    message: "Required parameters are missing", details: nil))
            return
        }
        guard let options = options(for: optionID) else {
            result(
                FlutterError(
                    code: "INVALID_OPTION",
                    message: "Unsupported conversion option", details: nil))
            return
        }
        // Each call owns its converter, including concurrent background calls.
        // SwiftyOpenCC resolves its packaged dictionaries; no runtime downloads.
        let convert = {
            let value: Any
            do {
                let converter = try ChineseConverter(options: options)
                value = converter.convert(text)
            } catch {
                value = FlutterError(
                    code: "CONVERSION_FAILED",
                    message: error.localizedDescription, details: nil)
            }
            if inBackground {
                DispatchQueue.main.async { result(value) }
            } else {
                result(value)
            }
        }
        if inBackground {
            DispatchQueue.global(qos: .userInitiated).async(execute: convert)
        } else {
            convert()
        }
    }
}
