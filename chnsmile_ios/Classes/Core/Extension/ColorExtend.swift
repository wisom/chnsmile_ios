//
//  UIColor.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/4.
//

import UIKit

extension UIColor {
    /// 通过16进制颜色创建Color
    ///
    /// - Parameter hex: 16进制颜色
public convenience init(hex: Int) {
        //从Int提取出每个颜色
        //最高2位表示红色
        //中间2位表示绿色
        //最低2位表示蓝色
        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0xFF00) >> 8
        let blue = (hex & 0xFF)

        //转成0~1
        let redDouble = Double(red) / 255.0
        let greenDouble = Double(green) / 255.0
        let blueDouble = Double(blue) / 255.0

        //调用Color的初始化方法
        self.init(red: CGFloat(redDouble), green: CGFloat(greenDouble), blue: CGFloat(blueDouble), alpha: 1.0)
    }
}
