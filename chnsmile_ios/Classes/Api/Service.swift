//
//  Service.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import Foundation
import Moya

enum Service {
    case origin(phone: String, isStaff: Int)
    case login(phone: String?, password: String?, userIdentity: Int?)
    case getUserInfo
    case getUnReadNum
    case uploadCid(cid: String?)
}

// MARK: - 实现TargetType协议
extension Service: TargetType {
    
    /// 返回网址
    var baseURL: URL {
        switch self {
        case .origin:
            return URL(string: ENDPOINT2)!
        default:
            let url = UserDefaults.standard.object(forKey: KEY_URL)!
            return URL(string: url as! String)!
        }
    }
    
    /// 返回请求路径
    var path: String {
        switch self {
        case .origin:
            return "platformRegionUser/default/list"
        case .login:
            return "app-api/mobileLogin"
        case .getUserInfo:
            return "app-api/getLoginUser"
        case .getUnReadNum:
            return "app-api/app/user/tab/unReadNum"
        case .uploadCid:
            return "app-api/app/user/push/bindCidAndAlias"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .uploadCid:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login(let phone, password: let password, userIdentity: let userIdentity):
            return HttpUtil.jsonRequestParamters(["phone": phone, "password": password, "userIdentity": userIdentity])
        case .uploadCid(cid: let cid):
            return HttpUtil.jsonRequestParamters(["cid": cid!, "brand": "IOS"])
        case .origin(phone: let phone, isStaff: let isStaff):
            return HttpUtil.getRequestParamters(["account": phone, "isStaff": isStaff])
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var headers: Dictionary<String, String> = [:]
    
        // 内容的类型
        headers["Content-Type"] = "application/json"
        if PreferenceUtil.isLogin() {
            // 登陆了
            let user = PreferenceUtil.userId()
            let token = PreferenceUtil.userToken()

            if DEBUG {
                //打印token
                print("Service headers user:\(user),token:\(token)")
            }

            //传递登录标识
            headers["Authorization"] = (token != nil) ? "Bearer " + token!  : ""
        }
        return headers
    }
    
    /// 返回测试相关的路径
    var sampleData: Data {
        return Data()
    }
}
