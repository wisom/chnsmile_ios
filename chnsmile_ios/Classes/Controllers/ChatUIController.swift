//
//  ChatUIController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/10/14.
//

import Foundation
import TUICore
import TUIChat

class ChatUIController: TUIC2CChatViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let more = NSMutableArray.init()
        for item in self.moreMenus {
            if(item.title == "图片" || item.title == "拍照" || item.title == "录像" || item.title == "文件"  ) {
                more.add(item)
            }
        }
        
        self.moreMenus = NSArray.init(array: more) as? [TUIInputMoreCellData]
    }
    

}
