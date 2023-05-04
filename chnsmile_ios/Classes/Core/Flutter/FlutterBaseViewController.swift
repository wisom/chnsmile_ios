//
//  FlutterBaseViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/15.
//

import UIKit
import flutter_boost

class FlutterBaseViewController: FBFlutterViewContainer {

    override func viewDidLoad() {
        super.viewDidLoad()
        let channel = FlutterMethodChannel.init(name: "com.icefire.chnsmile/api", binaryMessenger: self.binaryMessenger)
        
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            print("flutter call native：\n method=\(call.method) \n arguments = \(String(describing: call.arguments))")
            // 获取UA
            FlutterBridgetGetUserAgent.registerAPI(call: call, result: result)
            // 获取UserInfo
            FlutterBridgeGetUserInfo.registerAPI(call: call, result: result)
            // 退出登录
            FlutterBridgeLogout.registerAPI(call: call, result: result)
        }
    }
    

   

}
