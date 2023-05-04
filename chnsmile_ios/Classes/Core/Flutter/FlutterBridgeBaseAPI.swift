//
//  FlutterBridgeBaseAPI.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/15.
//

import UIKit

class FlutterBridgeBaseAPI: NSObject {

    class func registerAPI(call: FlutterMethodCall, result: @escaping FlutterResult){
        if call.method==apiName() {
            //当前api
            processWithAPI(call: call, result: result);
        }
    }
    
    ///子类实现的方法
    class func apiName()->String{
        return "";
    }
    
    ///具体API的操作
    class func processWithAPI(call: FlutterMethodCall, result: @escaping FlutterResult){
        
    }
}
