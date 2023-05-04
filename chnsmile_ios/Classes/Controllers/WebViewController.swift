//
//  WebViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/13.
//

import UIKit
import WebKit
import WKWebViewJavascriptBridge
import Alamofire

class WebViewController: BaseTitleController,UIGestureRecognizerDelegate {

    /// webview控件
    var webView: WKWebView!
    var refreshLabel: UILabel!
    
    /// 地址
    var uri: String!
    var shareTitle: String!
    
    var bridge: WKWebViewJavascriptBridge!
    
    let timeoutInterval: TimeInterval = 5 // 设置超时时间为10秒
    var timer: Timer?

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: webConfig)
        webView.backgroundColor = .white
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)

        refreshLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        refreshLabel.center = view.center
        refreshLabel.textAlignment = .center
        refreshLabel.text = "页面加载超时，请点击刷新"
        refreshLabel.font = UIFont.systemFont(ofSize: 13)
        refreshLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(refresh))
        refreshLabel.addGestureRecognizer(tapGesture)
        webView.addSubview(refreshLabel)
    }
    
    @objc func rightClick() {
        print("self.shareTitle: ", self.shareTitle)
//        if self.shareTitle == nil || self.shareTitle == "" {
        if !isAttach() {
            DispatchQueue.main.async {
                let items = [URL(string: self.uri)]
                
                let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    //                    activityController.modalPresentationStyle = .fullScreen
                        activityController.completionWithItemsHandler = {
                            (type, flag, array, error) -> Void in
                            if flag == true {
            
                            } else {
            
                            }
                        }
                        self.present(activityController, animated: true, completion: nil)
            }
        } else {
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            Alamofire.download(self.uri, to: destination).response { response in
                if let data = response.destinationURL {
                    print("data: ", response.destinationURL?.path)
                    let path = response.destinationURL?.path
                    DispatchQueue.main.async {
                        let title = self.shareTitle ?? "分享内容"
                        let items = [NSURL.fileURL(withPath: path!)]
                        
                        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            //                    activityController.modalPresentationStyle = .fullScreen
                                activityController.completionWithItemsHandler = {
                                    (type, flag, array, error) -> Void in
                                    if flag == true {
                    
                                    } else {
                    
                                    }
                                }
                                self.present(activityController, animated: true, completion: nil)
                    }
                }
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateHeight()
    }
    
    func updateHeight() {
        if (uri != nil && (uri.lowercased().contains(".png")
                           || uri.lowercased().contains(".jpg")
                           || uri.lowercased().contains(".jpeg")
                           || uri.lowercased().contains(".webp")
                           || uri.lowercased().contains(".gif")
        )) {
            self.view?.frame = CGRect.init(x: 0, y: 88, width: view.bounds.width, height: view.bounds.height)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeight()
    }
    
    override func hideNavigationBar() -> Bool {
        return false
    }
    
    func isAttach() -> Bool {
        return uri.lowercased().contains(".png")
                || uri.lowercased().contains(".jpg")
                || uri.lowercased().contains(".jpeg")
                || uri.lowercased().contains(".webp")
                || uri.lowercased().contains(".gif")
                || uri.lowercased().contains(".pdf")
                || uri.lowercased().contains(".doc")
                || uri.lowercased().contains(".docx")
                || uri.lowercased().contains(".xls")
                || uri.lowercased().contains(".ppt")
                || uri.lowercased().contains(".txt")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if (uri != nil && (uri.lowercased().contains(".png")
                           || uri.lowercased().contains(".jpg")
                           || uri.lowercased().contains(".jpeg")
                           || uri.lowercased().contains(".webp")
                           || uri.lowercased().contains(".gif")
                           || uri.lowercased().contains(".pdf")
                           || uri.lowercased().contains(".doc")
                           || uri.lowercased().contains(".docx")
                           || uri.lowercased().contains(".xls")
                           || uri.lowercased().contains(".ppt")
                           || uri.lowercased().contains(".txt")
        )) {
            setTitle("附件详情")
        } else {
            setTitle("详情")
        }
        bridge = WKWebViewJavascriptBridge(webView: webView)
        
        bridge.register(handlerName: "openNative") { (paramters, callback) in
                    print("openNative called: \(String(describing: paramters))")
                    let url = paramters!["url"] ?? "";
                    let newPageName = (url as AnyObject).replacingOccurrences(of: "smile://", with: "")
                    guard let targetViewController = SXRouter.matchToVC(route: newPageName) else {
                        print("not found:", newPageName)
                        return;
                    }
                    
                   self.navigationController?.pushViewController(targetViewController, animated: true)

                }
        
        bridge.register(handlerName: "openMedia") { (paramters, callback) in
            print("openMedia called: \(String(describing: paramters))")
            let url = paramters!["url"] ?? "";
            let title = paramters!["title"] ?? "";
            let vc = WebViewController()
            vc.uri = url as? String
            vc.shareTitle = title as? String
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 设置 WKNavigationDelegate
        webView.navigationDelegate = self
    }
    
    @objc func refresh() {
        refreshLabel.isHidden = true
        ToastUtil.showLoading()
        webView.reload()
        ToastUtil.hideLoading()
        refreshLabel.isHidden = false
    }
    
    override func initViews() {
        super.initViews()
        //设置UI代理
        webView.uiDelegate = self
        //导航代理
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if  navigationAction.targetFrame?.isMainFrame == nil{
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ToastUtil.showLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        timer?.invalidate()
        ToastUtil.hideLoading()
        refreshLabel.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ToastUtil.hideLoading()
        // 显示刷新标签
        showRefreshLabel()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // 显示刷新标签
        showRefreshLabel()
        ToastUtil.hideLoading()
    }
    
    func showRefreshLabel() {
        refreshLabel.isHidden = false
    }
    
    override func initDatas() {
        super.initDatas()
        var pUrl = params["url"] ?? uri ?? ""
        let pTitle = params["title"] ?? ""
        print("url: ", pUrl, pTitle)
        uri = pUrl as! String;
        if !(uri.contains("http") || uri.contains("https")) {
            pUrl = "file://\(pUrl as! String)"
        }
        shareTitle = pTitle as! String;
        let url = URL(string: pUrl as! String)!
        print("url===: ", url)
        //创建request
        let myRequest = URLRequest(url: url)
        
        if uri.contains("http") || uri.contains("https") {
            let rightItem = UIBarButtonItem(title: "分享", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightClick))
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
        //使用webview加载这个请求
        webView.load(myRequest)
        
        timer = Timer.scheduledTimer(withTimeInterval: timeoutInterval, repeats: false) { [weak self] timer in
            // 如果计时器到期并且网页仍未加载完成，则视为加载超时
            ToastUtil.hideLoading()
            if self?.webView.isLoading == true {
                self?.webView.stopLoading()
                // 显示刷新标签
                self?.showRefreshLabel()
                ToastUtil.hideLoading()
            }
        }
        // 隐藏刷新标签
        refreshLabel.isHidden = true
    }
}

// MARK: - WKUIDelegate代理
extension WebViewController: WKUIDelegate{
    
}

// MARK: - WKNavigationDelegate代理
extension WebViewController: WKNavigationDelegate {

}

// MARK: - 启动界面
extension WebViewController {
    /// 启动界面
    ///
    /// - Parameters:
    ///   - navigationController: 导航控制器
    ///   - title: 显示的标题
    ///   - uri: 显示的网址
    static func start(_ navigationController:UINavigationController, _ title:String,_ uri:String) {
        //创建控制器
        let controller = WebViewController()
        
        //传递参数
        controller.title=title
        controller.uri=uri
        
        //将控制器压入导航控制器中
        navigationController.pushViewController(controller, animated: true)
    }
}
