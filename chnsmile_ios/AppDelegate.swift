//
//  AppDelegate.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/4.
//

import UIKit
import flutter_boost
import TUICore
import UserNotifications
import PushKit
import AVFoundation
import AppTrackingTransparency
import AdSupport
import SwiftEventBus
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GeTuiSdkDelegate {

    var window: UIWindow?
    var delegate: BoostDelegate?
    let disposeBag = DisposeBag()
    
    open class var shared: AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 初始化全局属性
        initStyle()
        
        // 初始化操作 创建fluter boost代理
        delegate = BoostDelegate()
        FlutterBoost.instance().setup(application, delegate: delegate) { engine in
        }
        
        // 初始化router
        initRouter()
        
        // 初始化IM
        initIM()
        
        //初始化推送
        initGeTui()
        
        return true
    }
    
    //MARK: - 页面属性
    func initStyle() {
        UITabBar.appearance().tintColor = UIColor(hex: COLOR_PRIMARY)
        var img = UIImage.init(named: "common_icon_back")!.resizeWith(width: 7)!

        let leftPadding: CGFloat = 10
        let adjustSizeForBetterHorizontalAlignment: CGSize = CGSize(width: img.size.width + leftPadding, height: img.size.height)

        UIGraphicsBeginImageContextWithOptions(adjustSizeForBetterHorizontalAlignment, false, 0)
        img.draw(at: CGPoint.init(x: leftPadding, y: 0))
        img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(hex: COLOR_PRIMARY)
            appearance.shadowColor = .white
            
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20) as Any, NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.shadowImage = UIImage()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barStyle = .default
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage.imageWithColor(color: UIColor(hex: COLOR_PRIMARY)), for: .default)

            let navbarTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: adaptfontSize(16), weight: .medium)
            ]

            UINavigationBar.appearance().backIndicatorImage = img
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = img

            UINavigationBar.appearance().titleTextAttributes = navbarTitleTextAttributes as [NSAttributedString.Key : Any]
        }
    }
    
    // MARK: - 初始化个推
    func initGeTui() {
//        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
//        print("idfa=\(idfa)")
//        if #available(iOS 14, *) {
//
//          /*
//           ATTrackingManager.requestTrackingAuthorization调用之前，需要在 Info.plist 中配置
//           <key>NSUserTrackingUsageDescription</key>
//           <string>该标识符将用于向您投放个性化广告</string>
//           */
//
//          ATTrackingManager.requestTrackingAuthorization { status in
//            print("status=\(status), idfa=\(idfa)")
//            GeTuiSdk.setIDFA(idfa)
//          }
//        } else {
//          GeTuiSdk.setIDFA(idfa)
//        }
        
        // [ GTSDK ]：使用APPID/APPKEY/APPSECRENT启动个推
        GeTuiSdk.start(withAppId: kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate: self)
        
        // [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
        GeTuiSdk.registerRemoteNotification([.alert, .badge, .sound])
    }
    
    // MARK: - 初始化IM
    func initIM() {
        TUILogin.initWithSdkAppID(Int32(IM_APPID))
    }
    
    //MARK: - 初始化Router
    func initRouter() {
        // smile:///sp/webview
        SXRouter.map(route: "/sp_webview", vcClass: WebViewController.self)
        SXRouter.map(route: "/sp_chat", vcClass: ChatViewController.self)
        SXRouter.map(route: "/sp_attachment", vcClass: WebViewController.self)
        SXRouter.map(route: "/sp_picture", vcClass: WebViewController.self)
    }
    
    //MARK: - 替换RootVController
    /// 设置根控制器
    func setRootViewController(name: String, isNav: Bool) {
        // 先获取 Main.StoryBoard实例, buidle 传入nil，会使用bundleid
        let mainStory = UIStoryboard(name: "Main", bundle: nil)
        
        // 关联控制器
        let controller = mainStory.instantiateViewController(withIdentifier: name)
        if (isNav) {
            let nav = UINavigationController(rootViewController: controller)
            // 替换根控制器，不希望用户返回启动页面
            window!.rootViewController = nav
            delegate?.navigationController = nav
        } else {
            window!.rootViewController = controller
        }
    }
    
    
    /// 跳转到隐私页面
    func toProtocal() {
        setRootViewController(name: "Protocal", isNav: false)
    }

    /// 跳转到引导页面
    func toGuide() {
        setRootViewController(name: "Guide", isNav: false)
    }
    
    /// 跳转到登录/注册界面
    func toLogin() {        
        setRootViewController(name: "Login", isNav: true)
    }
    
    /// 跳转到首页
    func toHome() {
        PreferenceUtil.setLoginSuccess(true)
        let tabBarController = MainViewController()
        let navigationViewController = UINavigationController(rootViewController: tabBarController)
        navigationViewController.navigationBar.isHidden = true
        window?.rootViewController = navigationViewController
        delegate?.navigationController = navigationViewController
    }
    
    /// 退出
    func logout() {
        //清除用户信息
        PreferenceUtil.logout()
        TUILogin.logout(nil, fail: nil)

        //跳转到登录注册页面
        toLogin()
    }
    
    // MARK: - GeTuiSdkDelegate
    /// [ GTSDK回调 ] SDK启动成功返回cid
    func geTuiSdkDidRegisterClient(_ clientId: String) {
      let msg = "[ TestDemo ] \(#function):\(clientId)"
      print("msg clientId: ", msg)
        PreferenceUtil.setCid(clientId)
        let url = UserDefaults.standard.object(forKey: KEY_URL)
        if (url == nil) {
            return
        }
        Api.shared.uploadCid(cid: clientId).subscribeOnSuccess { data in
            if let data = data?.data {
                //上传成功
                print("upload success:\(data)")
                
            }
        }.disposed(by: disposeBag)
    }
    
    
    /// [ GTSDK回调 ] SDK错误反馈
    func geTuiSdkDidOccurError(_ error: Error) {
      let msg = "[ TestDemo ] \(#function) \(error.localizedDescription)"
        print("msg: ", msg)
    }
    
    //MARK: - 通知回调
    /// [ 系统回调 ] iOS 10及以上  APNs通知将要显示时触发
    @available(iOS 10.0, *)
    func geTuiSdkNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let msg = "[ TestDemo ] \(#function)"
        print("msg: ", msg)
      // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要，判断是否要提示用户Badge、Sound、Alert等
      completionHandler([.badge, .sound, .alert])
    }
    
    @available(iOS 10.0, *)
    func geTuiSdkDidReceiveNotification(_ userInfo: [AnyHashable : Any], notificationCenter center: UNUserNotificationCenter?, response: UNNotificationResponse?, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
      let msg = "[ TestDemo ] \(#function) \(userInfo)"
        print("msg: ", msg)
      // [ 参考代码，开发者注意根据实际需求自行修改 ]
      completionHandler?(.noData)
    }
    
    func geTuiSdkDidReceiveSlience(_ userInfo: [AnyHashable : Any], fromGetui: Bool, offLine: Bool, appId: String?, taskId: String?, msgId: String?, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
      let msg = "[ TestDemo ] \(#function) fromGetui:\(fromGetui ? "个推消息" : "APNs消息") appId:\(appId ?? "") offLine:\(offLine ? "离线" : "在线") taskId:\(taskId ?? "") msgId:\(msgId ?? "") userInfo:\(userInfo)"
        print("msg: ", msg)
        FlutterBoost.instance().sendEventToFlutter(with: "triggerUnRead", arguments: ["data":"event from native"])
        SwiftEventBus.post("unRead")
    }
    
    @available(iOS 10.0, *)
    func geTuiSdkNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
      // [ 参考代码，开发者注意根据实际需求自行修改 ]
    }
}

