//
//  SplashViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/4.
//

import UIKit

class SplashViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 延迟3秒
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.next()
        }
    }
    
    /// 隐藏状态栏
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - 方法区
extension SplashViewController {
    private func next() {
        if PreferenceUtil.isShowProtocal() {
            // 显示隐私页面
            AppDelegate.shared.toProtocal()
        } else if PreferenceUtil.isShowGuide() {
            // 显示引导页面
            AppDelegate.shared.toGuide()
        } else if PreferenceUtil.isLogin() {
            // 已经登录
            AppDelegate.shared.toHome()
        } else {
            // 跳转到登录页面
            AppDelegate.shared.toLogin()
        }
    }
}
