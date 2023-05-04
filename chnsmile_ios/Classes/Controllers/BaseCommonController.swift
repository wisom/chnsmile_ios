//
//  BaseCommonController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import UIKit
import RxSwift

class BaseCommonController: BaseViewController {

    //负责对象销毁
    //这个功能类似NotificationCenter的removeObserver
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
