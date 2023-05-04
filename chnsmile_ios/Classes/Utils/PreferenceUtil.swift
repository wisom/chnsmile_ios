//
//  PreferenceUtil.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import Foundation

class PreferenceUtil {
    
    /// 是否登录成功
    static func isLoginSuccess() -> Bool {
        return UserDefaults.standard.bool(forKey: KEY_LOGIN_SUCCESS)
    }
    
    /// 设置登录成功
    static func setLoginSuccess(_ data: Bool) {
        UserDefaults.standard.set(data, forKey: KEY_LOGIN_SUCCESS)
    }
    
    /// 是否显示隐私页面
    static func isShowProtocal() -> Bool {
        let isShowProtocal = UserDefaults.standard.bool(forKey: KEY_PROTOCAL)
        return !isShowProtocal
    }
    
    /// 设置是否显示隐私页面
    static func setShowProtocal(_ data: Bool) {
        UserDefaults.standard.set(data, forKey: KEY_PROTOCAL)
    }
    
    
    /// 是否显示引导页面
    static func isShowGuide() -> Bool {
        let isShowGuide = UserDefaults.standard.bool(forKey: KEY_GUIDE)
        return !isShowGuide
    }
    
    /// 设置是否显示引导页面
    static func setShowGuide(_ data: Bool) {
        UserDefaults.standard.set(data, forKey: KEY_GUIDE)
    }
    
    /// 设置用户id
    static func userId(_ data: String) {
        UserDefaults.standard.set(data, forKey: KEY_USER_ID)
    }
    
    /// 获取用户id
    static func userId() -> String? {
        return UserDefaults.standard.string(forKey: KEY_USER_ID)
    }
    
    /// 设置用户Account
    static func userAccount(_ data: String) {
        UserDefaults.standard.set(data, forKey: KEY_USER_ACCOUNT)
    }
    
    /// 获取用户Account
    static func userAccount() -> String? {
        return UserDefaults.standard.string(forKey: KEY_USER_ACCOUNT)
    }
    
    /// 保存用户会话标识
    static func setUserToken(_ data: String) {
        UserDefaults.standard.set(data, forKey: KEY_USER_TOKEN)
    }
    
    /// 获取用户会话标识
    static func userToken() -> String?{
        return UserDefaults.standard.string(forKey: KEY_USER_TOKEN)
    }
    
    /// 保存cid
    static func setCid(_ data: String) {
        UserDefaults.standard.set(data, forKey: KEY_CID)
    }
    
    /// 获取cid
    static func getCid() -> String?{
        return UserDefaults.standard.string(forKey: KEY_CID)
    }
    
    /// 设置用户信息
    static func setUserInfo(_ data: User) {
        data.baseUrl = ENDPOINT;
        data.lastChildId = userId();
        UserDefaults.standard.set(data.toJSONString()!, forKey: KEY_USER_INFO)
    }
    
    /// 获取用户信息
    static func getUserInfo() -> User? {
        let data = UserDefaults.standard.string(forKey: KEY_USER_INFO)
        return JsonUtil.jsonToModel(data!, User.self) as? User
    }

    
    /// 是否登录
    static func isLogin() -> Bool {
        if let _ = userToken() {
            return true
        } else {
            return false
        }
    }
    
    /// 退出
    static func logout() {
        //清除用户
        UserDefaults.standard.removeObject(forKey: KEY_USER_ID)
        UserDefaults.standard.removeObject(forKey: KEY_USER_INFO)
        
        // 清除用户登录 标识
        UserDefaults.standard.removeObject(forKey: KEY_USER_TOKEN)
        UserDefaults.standard.removeObject(forKey: KEY_URL)
        UserDefaults.standard.removeObject(forKey: KEY_LOGIN_SUCCESS)
        // 立即将变更写入磁盘
        UserDefaults.standard.synchronize()
    }
}
