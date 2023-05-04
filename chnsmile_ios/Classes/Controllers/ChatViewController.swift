//
//  ChatViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/22.
//

import UIKit
import TUICore
import TUIChat
import flutter_boost

class ChatViewController: BaseTitleController {
    
    // 用户ID
    var userID: String!
    
    // 用户姓名
    var userName: String!
    
    override func hideNavigationBar() -> Bool {
        return false
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = params["id"]! as! String
        userName = params["name"]! as! String
        
        self.navigationItem.title = userName
        let item = UIBarButtonItem(title: "举报", style: .plain, target: self, action: #selector(rightClick))
        self.navigationItem.rightBarButtonItem = item
        
        let conversationData = TUIChatConversationModel()
        conversationData.userID = userID
        conversationData.title = userName
        
        TUIConfig.default().defaultAvatarImage = UIImage(named: "default_avator")
        
        let chatVC = ChatUIController()
        chatVC.conversationData = conversationData
        
//        let user = PreferenceUtil.getUserInfo();
//        TUILogin.login(user?.id, userSig: user?.imUserSign) {
//        } fail: { code, message in
//        }
        
        addChild(chatVC)
        view.addSubview(chatVC.view)
    }

    @objc func rightClick() {
        self.navigationController?.navigationBar.isHidden = true
        FlutterBoost.instance().open("feedback_page", arguments: ["isFromChat":true], completion: nil)
    }
    
}
