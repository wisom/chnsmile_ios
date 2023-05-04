//
//  UIImage+Extension.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/14.
//

import UIKit

extension UIImage {
    
    public class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0 / UIScreen.main.scale)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1.0, height: 1.0 / UIScreen.main.scale),
                                               false,
                                               UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    
    public func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
