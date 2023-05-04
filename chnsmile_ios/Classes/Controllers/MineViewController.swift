//
//  MineViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/4.
//

import UIKit
import flutter_boost

class MineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white

        let button = UIButton()
        button.frame = CGRect(x: 100, y: 200, width: 120, height: 40)
        button.backgroundColor = UIColor.blue
        button.setTitle("点我", for: .normal)
        button.addTarget(self, action: #selector(click), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc private func click() {
        let options = FlutterBoostRouteOptions()
        options.pageName = "about_page"
        //这个是push操作完成的回调，而不是页面关闭的回调！！！！
        options.completion = { completion in
            print("打开Flutter页面了")
            print("open operation is completed")
        }
        
        //这个是页面关闭并且返回数据的回调，回调实际需要根据您的Delegate中的popRoute来调用
        options.onPageFinished = { dic in
            print("Flutter页面关闭回调了")
            print(dic as Any)
        }

        FlutterBoost.instance().open(options)
    }
    
    
}
