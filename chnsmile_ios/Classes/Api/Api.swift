//
//  Api.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import Foundation
import HandyJSON
import RxSwift
import Moya

class Api {
    // 饿汉式 设计模式
    static let shared = Api()
    
    private let provider: MoyaProvider<Service>!

    private init() {
        var plugins: [PluginType] = []
        if DEBUG {
            //表示当前是调试模式
            //添加网络请求日志插件
            plugins.append(NetworkLoggerPlugin())
        }
        
        //网络请求加载对话框
        let networkActivityPlugin = NetworkActivityPlugin { (changeType, targetType) in
            //changeType类型是NetworkActivityChangeType，通过它能监听到开始请求和结束请求
            //targetType类型是TargetType，就是我们这里的service,通过它能判断是哪个请求
            if changeType == .began {
                // 开始请求
                let targetType = targetType as! Service
                switch targetType {
                case .login:
                    print("显示对话框")
//                    ToastUtil.showLoading()
                default:
                    break
                }
            } else {
                // 结束请求
                print("结束对话框")
//                ToastUtil.hideLoading()
            }
        }
        plugins.append(networkActivityPlugin)
        
        provider = MoyaProvider<Service>(plugins: plugins)
    }
    
    /// 获取域名
    func origin(phone: String, isStaff: Int) -> Observable<ListResponse<Origin>?> {
        return provider
            .rx
            .request(.origin(phone: phone, isStaff: isStaff))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
            .mapObject(ListResponse<Origin>.self)
    }
    
    /// 登录
    func login(phone: String, password: String, userIdentity: Int) -> Observable<StringResponse?> {
        return provider
            .rx
            .request(.login(phone: phone, password: password, userIdentity: userIdentity))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
            .mapObject(StringResponse.self)
            
    }
    
    /// 上传uid
    func uploadCid(cid: String) -> Observable<StringResponse?> {
        return provider
            .rx
            .request(.uploadCid(cid: cid))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
            .mapObject(StringResponse.self)
            
    }

    ///  获取用户信息
    func getUserInfo() -> Observable<DetailResponse<User>?> {
        return provider
            .rx
            .request(.getUserInfo)
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
            .mapObject(DetailResponse<User>.self)
    }
    
    ///  获取未读数
    func getUnReadNum() -> Observable<DetailResponse<UnReadNum>?> {
        return provider
            .rx
            .request(.getUnReadNum)
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
            .mapObject(DetailResponse<UnReadNum>.self)
    }
}
