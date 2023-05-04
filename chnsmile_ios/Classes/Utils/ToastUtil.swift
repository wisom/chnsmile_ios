//
//  ToastUtil.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/13.
//

import UIKit
import MBProgressHUD

class ToastUtil {
    private static var hud: MBProgressHUD?
    
    /// 显示一个短时间（1秒钟）的提示
    ///
    /// - Parameter message: 需要显示的消息
    static func short(_ message:String) {
        
        // 创建 一个 MBProgressHUD
        let hud = MBProgressHUD.showAdded(to: AppDelegate.shared.window!.rootViewController!.view, animated: true)
        
        // 只显示文字
        hud.mode = .text
        
        // 小矩形的背景颜色
        hud.bezelView.color = UIColor.darkGray
        
        // 设置细节文本 显示的内容
        hud.detailsLabel.text = message
        
        // 设置 细节文本 的颜色
        hud.detailsLabel.textColor = UIColor.white
        
        // 1s后， 自动隐藏
        hud.hide(animated: true, afterDelay: 1)
    }
    
    /// 显示一个加载对话框
    static func showLoading(_ message:String) {
        // 创建一个 MBProgressHUD
        hud = MBProgressHUD.showAdded(to: AppDelegate.shared.window!.rootViewController!.view, animated: true)
        
        // 设置菊花的颜色
        hud!.activityIndicatorColor = UIColor(hex: COLOR_PRIMARY)
        
        // 设置背景模糊
        hud!.backgroundView.style = MBProgressHUDBackgroundStyle.solidColor
        
        // 设置背景半透明
        hud!.backgroundView.color = UIColor(white: 0.0, alpha: 0.1)
        
        // 小矩形的背景颜色
        hud!.bezelView.color = UIColor.white
        
        // 设置文本
        hud!.detailsLabel.text = message
        
        // 设置 文本 的颜色
        hud!.detailsLabel.textColor = UIColor(hex: COLOR_PRIMARY)
        
        // 显示
        hud!.show(animated: true)
    }
    
    /// 显示一个加载对话框; 使用默认文字
    static func showLoading() {
        showLoading("加载中...")
    }
    
    /// 隐藏加载提示对话框
    static func hideLoading() {
        if let hud = hud {
            hud.hide(animated: true)
            ToastUtil.hud = nil
        }
    }
}
