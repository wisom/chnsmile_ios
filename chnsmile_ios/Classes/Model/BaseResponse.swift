//
//  BaseResponse.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import Foundation
import HandyJSON

class BaseResponse: HandyJSON {
    
    /// 状态码
    /// 只有发生了错误才会有
    var code:Int?
    
    /// 错误信息
    /// 发生了错误不一定有
    var message:String?
    
    // JSON解析 需要的方法
    required init() {}
}
