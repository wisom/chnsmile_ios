//
//  ContactViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/4.
//

import UIKit
import flutter_boost

class ContactViewController: FlutterBaseViewController, V2TIMConversationListener {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        V2TIMManager.sharedInstance().addConversationListener(listener: self)
    }


    func onTotalUnreadMessageCountChanged(_ totalUnreadCount: UInt64) {
        FlutterBoost.instance().sendEventToFlutter(with: "triggerIM", arguments: ["data":"event from native"])
    }
}
