//
//  User.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/20.
//

import Foundation
import HandyJSON

class User: BaseModel {
    var id: String!     //会员号
    var imUserSign: String!   //im 的标识
    var account: String!
    var nickName: String!
    var name: String!
    var avatar: String!
    var birthday: String!
    var sex: String!
    var email: String!
    var tel: String!
    var defaultIdentity: Int!  // 1: 家长 2: 教师
    var schoolId: String!
    var lastChildId: String! // 学生ID
    var baseUrl: String!
    
    /// 是否是教师
    func isTeacher() -> Bool {
        if defaultIdentity == 2 {
            return true
        }
        return false
    }
}
