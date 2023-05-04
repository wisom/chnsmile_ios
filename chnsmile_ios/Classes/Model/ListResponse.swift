//
//  ListResponse.swift
//  chnsmile_ios
//
//  Created by chao on 2022/6/18.
//

import Foundation

import HandyJSON

class ListResponse<T:HandyJSON>: BaseResponse {

    /// 定义一个列表
    /// 里面的对象使用了泛型
    var data: Array<T>?
}
