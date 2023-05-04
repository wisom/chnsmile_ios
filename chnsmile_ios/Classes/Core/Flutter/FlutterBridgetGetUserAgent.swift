//
//  FlutterBridgetGetUserAgent.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/15.
//

import UIKit

class FlutterBridgetGetUserAgent: FlutterBridgeBaseAPI {

    ///方法名
    override class func apiName() -> String {
        return "getUserAgent"
    }
    
    ///具体API的操作
    override class func processWithAPI(call: FlutterMethodCall, result: @escaping FlutterResult){
        if let info = Bundle.main.infoDictionary {
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
            let userAgent = UserAgent()
            userAgent.appType = "iOS"
            userAgent.appVersion =  appVersion
            userAgent.model = DeviceUtil.getDeiveInfo()
            userAgent.appCode = appBuild
            
            let str = JsonUtil.modelToJson(FlutterResponse(data: JsonUtil.modelToJson(userAgent)))
            result(str)
        } else {
            result(FlutterError(code: "500", message: "获取UA失败", details: nil))
        }
        
    }
}
