//
//  StringExtend.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import Foundation

/// 手机号
/// 移动：134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188 198
/// 联通：130 131 132 145 155 156 166 171 175 176 185 186
/// 电信：133 149 153 173 177 180 181 189 199
/// 虚拟运营商: 170
let REGX_PHONE = "^(0|86|17951)?(13[0-9]|15[012356789]|16[6]|19[89]]|17[01345678]|18[0-9]|14[579])[0-9]{8}$"

extension String {
    
    /// 是否符合手机号格式
    public func isPhone() -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", REGX_PHONE)
        return predicate.evaluate(with: self)
    }
    
    /// 去除字符串首尾的空格和换行
    ///
    /// - Returns: 结果 字符串
    func trim() -> String? {
        let whitespce = NSCharacterSet.whitespacesAndNewlines
        return trimmingCharacters(in: whitespce)
    }
}
