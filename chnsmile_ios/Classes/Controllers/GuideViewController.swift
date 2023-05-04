//
//  GuideViewController.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import UIKit

class GuideViewController: BaseViewController {

    @IBOutlet weak var bannerView: YJBannerView!
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //初始化轮播图组件
        initBannerView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startButton.setTitle("", for: .normal)
    }
    
}

//MARK: - 事件
extension GuideViewController {
    @IBAction func startLoginClick(_ sender: UIButton) {
        // 调用它里面的方法显示登录/注册界面
        AppDelegate.shared.toLogin()
        setShowGuide()
    }
    
    /// 设置不显示引导界面
    func setShowGuide()  {
        PreferenceUtil.setShowGuide(true)
    }
}

//MARK: - view
extension GuideViewController {
    private func initBannerView() {
        // 设置轮播 数据源 代理
        bannerView.dataSource = self
        bannerView.delegate = self
        
        // 图片调用的方法
        bannerView.bannerViewSelectorString = "sd_setImageWithURL:placeholderImage:"
        
        // 禁用自动滚动功能
        bannerView.autoScroll = false
        
        bannerView.repeatCount = 1
        
        // 重新加载数据
        bannerView.reloadData()
    }
}

extension GuideViewController: YJBannerViewDataSource, YJBannerViewDelegate {
    
    ///  banner数据源
    func bannerViewImages(_ bannerView: YJBannerView!) -> [Any]! {
        return ["guide_01", "guide_02", "guide_03", "guide_04"];
    }
    
    func bannerView(_ bannerView: YJBannerView!, customCell: UICollectionViewCell!, index: Int) -> UICollectionViewCell! {
        // 将Cell转为YJBannerViewCell
        let cell = customCell as! YJBannerViewCell
        cell.showImageViewContentMode = .scaleAspectFit
        return cell
    }
}
