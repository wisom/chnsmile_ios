//
//  MainViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/4.
//

import UIKit
import flutter_boost
import TUICore
import RxSwift
import SwiftEventBus

class MainViewController: UITabBarController, V2TIMConversationListener, UITabBarControllerDelegate, V2TIMAPNSListener {
    
    let disposeBag = DisposeBag()
    
    var homeVc: FlutterBaseViewController!
    var newsVc: FlutterBaseViewController!
    var messageVc: FlutterBaseViewController!
    var oaVc: FlutterBaseViewController!
    var contactVc: FlutterBaseViewController!
    var teacherContactVc: FlutterBaseViewController!
    var mineVc: FlutterBaseViewController!
    var totalAppNum: Int = 0
    var timer: Timer!
    var removeListener:FBVoidCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ToastUtil.hideLoading()
        // 初始化tabbar
        setupTabBar()
//        GeTuiSdk.resetBadge()
//        UIApplication.shared.applicationIconBadgeNumber = 0
        // loadIM
        loadIM()
        // 上传cid
        uploadData()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.delegate = self
        SwiftEventBus.onMainThread(self, name: "unRead") { notification in
            print("SwiftEventBus==unRead")
            self.getUnReadNum()
         }
        
        self.removeListener =  FlutterBoost.instance().addEventListener({[weak self] key, dic in
            self!.getUnReadNum()
        }, forName: "triggerUnRead")
    }
    
    // 将进入前台通知
    @objc func appWillEnterForeground(){
        print("周期 ---将进入前台通知")
        let url = UserDefaults.standard.object(forKey: KEY_URL)
        if (url == nil) {
            return
        }
        getUnReadNum()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUnReadNum()
        
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self](_) in
            self?.getUnReadNum()
        }
    }
    
    
    func onTotalUnreadMessageCountChanged(_ totalUnreadCount: UInt64) {
        getUnReadNum()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("tabBarController.selectedIndex: ", tabBarController.selectedIndex)
        if tabBarController.selectedIndex == 3 {
            FlutterBoost.instance().sendEventToFlutter(with: "switchTab", arguments: ["data":"event from native"])
        }
    }
}


//MARK - 初始化
extension MainViewController {
    private func setupTabBar() {
        // 获取缓存的用户信息
        let user = PreferenceUtil.getUserInfo();
        // 获取参数
        let params = ["isFromNative":true, "token": PreferenceUtil.userToken()] as [String : Any]
        
        // 初始化四个flutter控制器
        homeVc  = FlutterBaseViewController()!
        homeVc.setName("home_page", uniqueId: nil, params: params, opaque: true)

        newsVc  = FlutterBaseViewController()!
        newsVc.setName("news_page", uniqueId: nil, params: params, opaque: true)
        
        messageVc  = FlutterBaseViewController()!
        messageVc.setName("message_page", uniqueId: nil, params: params, opaque: true)
        
        oaVc  = FlutterBaseViewController()!
        oaVc.setName("oa_page", uniqueId: nil, params: params, opaque: true)
        
        contactVc  = ContactViewController()!
        contactVc.setName("contact_page", uniqueId: nil, params: params, opaque: true)
        
        teacherContactVc  = ContactViewController()!
        teacherContactVc.setName("teacher_contact_page", uniqueId: nil, params: params, opaque: true)
        
        mineVc  = FlutterBaseViewController()!
        mineVc.setName("mine_page", uniqueId: nil, params: params, opaque: true)
        
        tabBar.backgroundColor = UIColor.white
        
        addChildViewController(childVc: homeVc, title: "首页", imageName: "tabbar_home")
        addChildViewController(childVc: newsVc, title: "专家论坛", imageName: "tabbar_news")
        if user?.defaultIdentity == 2 {
            addChildViewController(childVc: oaVc, title: "移动办公", imageName: "tab_oa")
            addChildViewController(childVc: teacherContactVc , title: "通讯录", imageName: "tabbar_contact")
        } else {
            addChildViewController(childVc: messageVc, title: "消息", imageName: "tabbar_message")
            addChildViewController(childVc: contactVc , title: "通讯录", imageName: "tabbar_contact")
        }
        
        addChildViewController(childVc: mineVc , title: "更多", imageName: "tabbar_mine")
    }
    
    private func addChildViewController(childVc: UIViewController, title: String, imageName: String) {
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        addChild(childVc)
    }
    
    private func loadIM() {
        V2TIMManager.sharedInstance().addConversationListener(listener: self)
        V2TIMManager.sharedInstance().setAPNSListener(self)
        let user = PreferenceUtil.getUserInfo()!
        TUILogin.login(user.id, userSig: user.imUserSign) {
            print("初始化iM成功")
        } fail: { code, message in
            ToastUtil.short("IM初始化失败")
            // 跳转到登录页面
//            AppDelegate.shared.toLogin()
        }
    }
    
    private func uploadData() {
        let cid = PreferenceUtil.getCid() ?? "";
        print("cid: ", cid)
        if (cid == "") {
            return
        }
        Api.shared.uploadCid(cid: cid).subscribeOnSuccess { data in
            if let data = data?.data {
                //上传成功
                print("upload success:\(data)")
                
            }
        }.disposed(by: disposeBag)
    }
    
    func onSetAPPUnreadCount() -> UInt32 {
        print("totalAppNum1: ", self.totalAppNum);
//        if (self.totalAppNum)
        return UInt32(self.totalAppNum)
    }
    
    private func getUnReadNum() {
        print("login: \(PreferenceUtil.isLogin()) ,userToken: \(PreferenceUtil.userToken())")
        if(!PreferenceUtil.isLoginSuccess()) {
            return
        }
        Api.shared.getUnReadNum().subscribeOnSuccess { data in
            if let data = data?.data {
                print("UnRead num info:\(data)")
                
                if (data.home != "0") {
                    self.homeVc.tabBarItem.badgeValue = data.home
                } else {
                    self.homeVc.tabBarItem.badgeValue = nil
                }
                
                if (data.zjlt != "0") {
                    self.newsVc.tabBarItem.badgeValue = data.zjlt
                } else {
                    self.newsVc.tabBarItem.badgeValue = nil
                }
                
                if (data.xx != "0") {
                    self.messageVc.tabBarItem.badgeValue = data.xx
                } else {
                    self.messageVc.tabBarItem.badgeValue = nil
                }
                
                if (data.ydbg != "0") {
                    self.oaVc.tabBarItem.badgeValue = data.ydbg
                } else {
                    self.oaVc.tabBarItem.badgeValue = nil
                }
                
                if (data.txl != "0") {
                    self.contactVc.tabBarItem.badgeValue = data.txl
                } else {
                    self.contactVc.tabBarItem.badgeValue = nil
                }
                
                if (data.txl != "0") {
                    self.teacherContactVc.tabBarItem.badgeValue = data.txl
                } else {
                    self.teacherContactVc.tabBarItem.badgeValue = nil
                }
                
                if (data.more != "0") {
                    self.mineVc.tabBarItem.badgeValue = data.more
                } else {
                    self.mineVc.tabBarItem.badgeValue = nil
                }
                
                if (data.app != nil && data.app != "0") {
                    var num = UInt(data.app) ?? 0
                    self.totalAppNum = Int(num)
//                    GeTuiSdk.setBadge(num)
                    UIApplication.shared.applicationIconBadgeNumber = self.totalAppNum
                } else {
//                    GeTuiSdk.setBadge(0)
                    self.totalAppNum = 0
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }.disposed(by: disposeBag)
    }
}
