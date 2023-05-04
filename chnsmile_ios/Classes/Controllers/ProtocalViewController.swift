//
//  ProtocalViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/4/11.
//

import UIKit

class ProtocalViewController: BaseViewController {
    
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    @IBOutlet weak var textView4: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContent()
    }
    
    func setupContent() {
        textView1.backgroundColor = UIColor.clear;
        textView2.backgroundColor = UIColor.clear;
        textView3.backgroundColor = UIColor.clear;
        textView4.backgroundColor = UIColor.clear;
        let tapTexts = ["《个人信息保护及隐私政策》", "《用户协议》"];
        let tapUrls = [PERSONAL_POLICY, AGREEMENT];
        let string = "您在使用微校产品/服务前，请仔细阅读并充分理解《个人信息保护及隐私政策》、《用户协议》。当您点击同意，即表示您已经理解并同意该条款，该条款将构成对您具有法律约束力的文件。"
        textView1.setupUserAgreements(string, tapTexts: tapTexts, tapUrls: tapUrls)
        textView1.delegate = self
        
        let tapTexts4 = ["《第三方SDK说明》"];
        let tapUrls4 = [THIRD_SDK_INSTRUCTIONS];
        let string4 = "未经您的单独同意，我们不会主动向任何第三方共享您的个人信息。当您使用一些功能服务时，我们可能会在获得您的明示同意后，从授权第三方处获取、共享或向其提供信息。您可阅读《第三方SDK说明》了解详细信息。"
        textView4.setupUserAgreements(string4, tapTexts: tapTexts4, tapUrls: tapUrls4)
        textView4.delegate = self
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
   
    @IBAction func disAgree(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "你需要同意本协议才能继续使用", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action:UIAlertAction!) in
            // 处理取消按钮点击事件
            alertController.dismiss(animated: false)
        }

        let viewProtocolAction = UIAlertAction(title: "查看协议", style: .default) { (action:UIAlertAction!) in
            // 处理查看协议按钮点击事件
            UIApplication.openURLStr(PERSONAL_POLICY, prefix: "http")
            alertController.dismiss(animated: false)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(viewProtocolAction)

        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func agree(_ sender: UIButton) {
        AppDelegate.shared.toGuide()
        PreferenceUtil.setShowProtocal(true)
    }
}

extension ProtocalViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        var url = URL.absoluteString;
        print("urlString",url)
        
        let regex = try! NSRegularExpression(pattern: "0_|1_", options: NSRegularExpression.Options.caseInsensitive)
        let range = NSMakeRange(0, url.count)
        url = regex.stringByReplacingMatches(in: url, options: [], range: range, withTemplate: "")
        print("urlString", url)
        
        UIApplication.openURLStr(url, prefix: "http")
        return true
    }
}

@objc public extension UITextView{

    /// 用户协议点击跳转配制方法
    func setupUserAgreements(_ content: String, tapTexts: [String], tapUrls: [String], tapColor: UIColor = UIColor.blue) {
        let attDic = [NSAttributedString.Key.foregroundColor: self.textColor ?? UIColor.gray,
                      NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 16)
        ]
        
        let attString = NSMutableAttributedString(string: content, attributes: attDic as [NSAttributedString.Key : Any])
        for e in tapTexts.enumerated() {
            let nsRange = (attString.string as NSString).range(of: e.element)
            attString.addAttribute(NSAttributedString.Key.link, value: "\(e.offset)_\(tapUrls[e.offset])", range: nsRange)
        }
        
        let linkAttDic = [NSAttributedString.Key.foregroundColor : UIColor(hex: COLOR_PRIMARY),
        ]
        linkTextAttributes = linkAttDic
        attributedText = attString
        isSelectable = true
        isEditable = false
    }
}

@objc public extension UIApplication{

    /// 打开网络链接(prefix为 http://或 tel:// )
    static func openURLStr(_ urlStr: String, prefix: String = "http") -> Bool {

        var tmp = urlStr;
        if urlStr.hasPrefix(prefix) == false {
            tmp = prefix + urlStr;
        }
        
        guard let url = URL(string:tmp) else { return false}
        let canOpenUrl = UIApplication.shared.canOpenURL(url)
        if canOpenUrl == true {

            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {

                UIApplication.shared.openURL(url);
            }
        } else {
            print("链接无法打开!!!\n%@",url as Any);
        }
        return canOpenUrl;
    }
}
