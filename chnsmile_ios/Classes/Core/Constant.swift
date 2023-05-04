//
//  Constant.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/4.
//

import Foundation

/// 是否是调试模式
let DEBUG = true

// MARK: - 开发环境
/// 网络接口的地址
//var ENDPOINT = "https://www.csmiledu.com/"
//var ENDPOINT2 = "https://www.csmiledu.com/"
var ENDPOINT = "http://yun3.csmiledu.com/"
var ENDPOINT2 = "http://yun3.csmiledu.com/"
let PERSONAL_POLICY = ENDPOINT2 + "app-api/app/school/page/platform/WX_USER_PRIVACY"
let AGREEMENT = ENDPOINT2 + "app-api/app/school/page/platform/WX_USER_AGREEMENT"
let THIRD_SDK_INSTRUCTIONS = ENDPOINT2 + "app-api/app/school/page/platform/WX_APP_SDK_EXPLAIN"


// MARK: - 颜色
/// 全局主色调
/// PRIMARY后缀其实是参考了Android中颜色的命名
let COLOR_PRIMARY = 0x00B0F0

// MARK: - 常量
let IM_APPID:Int = 1400627286
let kGtAppId = "GHfwFVWz5q7DpzLAmSqo12"
let kGtAppKey = "s6ZSvzh2CP8ZbFZ32XE7C6"
let kGtAppSecret = "CIoGzh3yai7DWwbVTreyw9"

// MARK: - 沙盒KEY
let KEY_LOGIN_SUCCESS = "KEY_LOGIN_SUCCESS"
let KEY_PROTOCAL = "KEY_PROTOCAL"
let KEY_GUIDE = "KEY_GUIDE"
let KEY_USER_ID = "KEY_USER_ID"
let KEY_USER_ACCOUNT = "KEY_USER_ACCOUNT"
let KEY_USER_TOKEN = "KEY_USER_TOKEN"
let KEY_USER_INFO = "KEY_USER_INFO"
let KEY_CID = "KEY_CID"
let KEY_URL = "KEY_URL"


func adaptfontSize(_ size: CGFloat) -> CGFloat {
    return UIScreen.isPlus ? size + 0.5 : size
}
