//
//  UIScreen.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/14.
//

import UIKit

extension UIScreen {
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    class var screenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }

    static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    static var isIphonex: CGRect {
        return UIScreen.main.bounds
    }
    
    static var hasSafeArea: Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        let bottom = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
        return bottom
    }
    
    static var isPlus: Bool {
        return  UIScreen.main.bounds.size.width > 400
    }
   
    static var upX: Bool {
        return hasSafeArea
    }
}
