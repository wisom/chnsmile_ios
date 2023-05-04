//
//  UITextField.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/11.
//

import UIKit

extension UITextField {
    
    /// 显示左侧图标
    func showLeftIcon(name: String) {
        leftView = UIImageView(image: UIImage(named: name))
        leftViewMode = .always
    }
}
