//
//  LoginViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import UIKit
import RxSwift
import flutter_boost
import TUICore
import CoreLocation

class LoginViewController: BaseTitleController {

    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var forgetButton: UIButton!
    
    @IBOutlet weak var familyButton: UIButton!
    @IBOutlet weak var teacherButton: UIButton!
    @IBOutlet weak var agreenButton: UIButton!
    
    // 用户标识 1 家长 2 老师
    var userIdentity = 1

    // 用户是否选择
    var isAgreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setTitle("用户登录")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        // 显示图标
        tfUsername.showLeftIcon(name: "ic_phone")
        tfPassword.showLeftIcon(name: "ic_password")
        
        tfUsername.text = PreferenceUtil.userAccount();
        forgetButton.addTarget(self, action: #selector(self.forget), for: .touchUpInside)
        
    }
    
    override func hideBackButton() -> Bool {
        return true
    }
    
    @IBAction func familyClick(_ sender: UIButton) {
        if self.userIdentity == 1 {
            return
        }
        self.userIdentity = 1
        familyButton.setImage(UIImage(named: "ic_checkbox_selected"), for: .normal)
        familyButton.setTitleColor(UIColor(hex: COLOR_PRIMARY), for: .normal)
        teacherButton.setImage(UIImage(named: "ic_checkbox_unselected"), for: .normal)
        teacherButton.setTitleColor(.gray, for: .normal)
    }
    @IBAction func teacherClick(_ sender: UIButton) {
        if self.userIdentity == 2 {
            return
        }
        self.userIdentity = 2
        familyButton.setImage(UIImage(named: "ic_checkbox_unselected"), for: .normal)
        familyButton.setTitleColor(.gray, for: .normal)
        teacherButton.setImage(UIImage(named: "ic_checkbox_selected"), for: .normal)
        teacherButton.setTitleColor(UIColor(hex: COLOR_PRIMARY), for: .normal)
    }
    
    @IBAction func agreenClick(_ sender: UIButton) {
        isAgreen = !isAgreen
        if isAgreen {
            agreenButton.setImage(UIImage(named: "ic_checkbox_small_selected"), for: .normal)
        } else {
            agreenButton.setImage(UIImage(named: "ic_checkbox_small_unselected"), for: .normal)
        }
    }
    
    @IBAction func privateClick(_ sender: UIButton) {
        UIApplication.openURLStr(PERSONAL_POLICY)
    }
    
    @IBAction func protocalClick(_ sender: UIButton) {
        UIApplication.openURLStr(AGREEMENT)
    }
    @IBAction func openClick(_ sender: UIButton) {
        ToastUtil.short("功能开发中...")
    }
    
    @IBAction func onLoginClick(_ sender: UIButton) {
        // 获取用户名
        let username = tfUsername.text!.trim()!
        if username.isEmpty {
            print("username is null")
            ToastUtil.short("请输入用户名")
            return
        }
        
        //获取密码
        let password = tfPassword.text!.trim()!
        if password.isEmpty {
            ToastUtil.short("请输入密码")
            return
        }
        
        if !isAgreen {
            ToastUtil.short("请同意服务协议及隐私政策")
            return
        }
        
        getOrigin(phone: username, password: password, userIdentity: self.userIdentity);
    }
    
}

//MARK - 事件点击
extension LoginViewController {
    
    @objc private func forget() {
        let options = FlutterBoostRouteOptions()
        options.pageName = "forget_page"
        self.navigationController?.navigationBar.isHidden = true
        FlutterBoost.instance().open(options)
    }
    
    func getOrigin(phone: String, password: String, userIdentity: Int) {
        Api.shared.origin(phone: phone, isStaff: userIdentity).subscribeOnSuccess { response in
            if let data1 = response?.data {
                print("Origin info:\(data1)")
                var url = ""
                if (data1.count > 0) {
                    let origin = data1[0]
                    
                    if (origin.onlineState == "2") {
                        ToastUtil.short("您所在的服务器不在线，请联系管理员")
                        return;
                    }
                    
                    if (origin.studentId != nil && origin.studentId != "") {
                        PreferenceUtil.userId(origin.studentId);
                    }
                    
                    if (origin.account != nil && origin.account != "") {
                        PreferenceUtil.userAccount(origin.account);
                    }
                    
                    if (origin.hostUrl != nil && origin.hostUrl != "") {
                        url = origin.hostUrl
                    }
                    
                    if (url == "" && origin.hostUrl1 != nil && origin.hostUrl1 != "") {
                        url = origin.hostUrl1
                    }
                    
            
                }
                
                if (url == "") {
                    url = ENDPOINT
                }
                UserDefaults.standard.set(url, forKey: KEY_URL)
                ENDPOINT = url
      
                
                // 登录
                self.login(phone: phone, password: password, userIdentity: self.userIdentity)
                
            }
        }.disposed(by: disposeBag)
    }
    
    
    func login(phone: String, password: String, userIdentity: Int) {
        ToastUtil.showLoading()
        Api.shared.login(phone: phone, password: password, userIdentity: userIdentity).subscribe({ data in
                    if let data = data?.data {
                        //登录成功
                        print("login success:\(data)")
                        // 保存token
                        PreferenceUtil.setUserToken(data)
                        // 家长用户接口
                        self.getUserInfo()
                        
                    }
                }) { (baseResponse, error) -> Bool in
                    ToastUtil.hideLoading()
                    return false
                }.disposed(by: disposeBag)

//        Api.shared.login(phone: phone, password: password, userIdentity: userIdentity).subscribeOnSuccess { data in
//            if let data = data?.data {
//                //登录成功
//                print("login success:\(data)")
//                // 保存token
//                PreferenceUtil.setUserToken(data)
//                // 家长用户接口
//                self.getUserInfo()
//
//            }
//        }.disposed(by: disposeBag)
    }
    
    func getUserInfo() {
        Api.shared.getUserInfo().subscribeOnSuccess { data in
            if let data = data?.data {
                print("user info:\(data)")
                // 保存用户信息
                PreferenceUtil.setUserInfo(data)
                // 加载im
                self.loadIM(data)
            }
        }.disposed(by: disposeBag)
    }
    
    func loadIM(_ user: User) {
        TUILogin.login(user.id, userSig: user.imUserSign) {
            //把登录成功的事件通知到AppDelegate
            ToastUtil.hideLoading()
            AppDelegate.shared.toHome()
        } fail: { code, message in
            ToastUtil.short("IM初始化失败")
            ToastUtil.hideLoading()
            AppDelegate.shared.toHome()
        }

    }
}
