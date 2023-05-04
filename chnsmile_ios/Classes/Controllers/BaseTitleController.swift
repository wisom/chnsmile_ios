//
//  BaseTitleController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import UIKit

class BaseTitleController: BaseCommonController {

    
    override func initViews() {
        super.initViews()
        
        //设置导航栏返回按钮颜色为黑色
        setNavigationBarTintColor(UIColor.white)
        // 设置返回按钮
        setNavigationBarLeftBarButtonItem()
    }

    /// 设置标题
    func setTitle(_ title: String) {
        navigationItem.title = title
    }

    /// 设置导航栏返回按钮颜色
    func setNavigationBarTintColor(_ color: UIColor) {
        navigationController!.navigationBar.tintColor = color
    }
    
    /// 设置导航栏返回按钮
    func setNavigationBarLeftBarButtonItem() {
        if !hideBackButton() {
            let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backToPrevious));
            backButtonItem.image = UIImage(named: "common_icon_back")
            self.navigationItem.leftBarButtonItem = backButtonItem;
        }
    }
    
    @objc func backToPrevious(){
        self.navigationController!.popViewController(animated: true)
    }

    /// 是否隐藏导航栏
    ///
    /// - Returns: true:隐藏；false:显示（默认）
    func hideNavigationBar() -> Bool {
        return false
    }
    
    /// 是否隐藏返回
    ///
    /// - Returns: true:隐藏；false:显示（默认）
    func hideBackButton() -> Bool {
        return false
    }

    /// 视图即将可见
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("BaseTitleController viewWillAppear")

        if hideNavigationBar() {
            //隐藏导航栏
            navigationController?.navigationBar.isHidden = true
        } else {
            navigationController?.navigationBar.isHidden = false
        }
    }

    /// 视图即将消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("BaseTitleController viewWillDisappear", self)
        if (!self.isKind(of: ChatViewController.self)) {
            navigationController?.navigationBar.isHidden = true
        }
        if hideNavigationBar() {
            //显示导航栏
            //因为其他界面可能不需要隐藏
//            navigationController!.setNavigationBarHidden(false, animated: true)
        }
    }
}
