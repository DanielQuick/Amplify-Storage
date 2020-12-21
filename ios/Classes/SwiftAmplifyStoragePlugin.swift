import Flutter
import UIKit
import Amplify
import AmplifyPlugins

public class SwiftAmplifyStoragePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "amplify_storage", binaryMessenger: registrar.messenger())
        let instance = SwiftAmplifyStoragePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "initialize":
                initialize(result: result)
            case "uploadFile":
                uploadFile(call: call, result: result)
            default:
                result(FlutterMethodNotImplemented);
        }
    }
    
    func initialize(result: @escaping FlutterResult) {
        do {
            try Amplify.add(plugin: AWSS3StoragePlugin())
            result(true)
        } catch {
            result(FlutterError(code: "", message: error.localizedDescription, details: nil))
        }
    }
    
    func uploadFile(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let arguments = call.arguments as? NSDictionary {
        
            var path = ""
            var key = ""
            var data: Data!

            if let arg = arguments["path"], let val = arg as? String {
                path = val
                let url = URL(fileURLWithPath: path)
                do {
                    data = try Data(contentsOf: url)
                } catch {
                    print(error)
                }
            }
            
            if let arg = arguments["key"], let val = arg as? String {
                key = val
            }
            
            Amplify.Storage.uploadData(key: key, data: data,
                                       progressListener: {progress in },
                                       resultListener: { (event) in
                    switch event {
                        case .success(let data):
                            print("success")
                            DispatchQueue.main.async {
                                result(true)
                            }
                        case .failure(let storageError):
                            print("failure")
                        DispatchQueue.main.async {
                            result(FlutterError(code: "", message: storageError.localizedDescription, details: nil))
                        }
                    }
            })
        }
    }
}
