//
//  FlutterBridgeGetUserInfo.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/15.
//

import UIKit

class FlutterBridgeGetUserInfo: FlutterBridgeBaseAPI {

    ///方法名
    override class func apiName()->String{
        return "getUserInfo";
    }
    ///具体API的操作
    override class func processWithAPI(call: FlutterMethodCall, result: @escaping FlutterResult){
        let user = PreferenceUtil.getUserInfo()
        if user != nil {
            let str = JsonUtil.modelToJson(FlutterResponse(data: JsonUtil.modelToJson(user)))
            result(str)
        } else {
            result(FlutterError(code: "500", message: "获取用户信息失败", details: nil))
        }
    }

}
