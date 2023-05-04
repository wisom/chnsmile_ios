//
//  DetailResponse.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import Foundation
import HandyJSON

class DetailResponse<T: HandyJSON>: BaseResponse {
    
    /// 真实数据
    var data: T?
}
