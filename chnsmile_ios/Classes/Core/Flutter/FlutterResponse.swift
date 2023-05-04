//
//  FlutterResponse.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/26.
//

import Foundation

class FlutterResponse: BaseModel {
    var code: Int = 0
    var msg: String?
    var data: String?
    
    init(data: String?) {
        self.data = data
        self.msg = "success"
        super.init()
    }
    
    required init() {
        code = 0
        msg = ""
        data = ""
        super.init()
    }
}
