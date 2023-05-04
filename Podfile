# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

flutter_application_path = '../chnsmile_flutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'chnsmile_ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  # TUIMessageController 修改forword
  # 因为接入im的原因 需要先打开 use_frameworks arch -x86_64 pod install ,再打开 use_modular_headers arch -x86_64 pod install
  # 如果出现 un dir 错误，移除pod header里面的public private错误
#  use_frameworks!
  use_modular_headers!

  install_all_flutter_pods(flutter_application_path)
  # Pods for chnsmile_ios
  
  # 提示框架
  pod 'MBProgressHUD', '~> 1.1.0'
  
  #图片加载
  pod 'SDWebImage', '~> 5.12.2'
  
  #响应式编程框架
  pod 'RxSwift', '~> 5'
  
  #网络库
  pod 'Moya/RxSwift', '14.0.0-alpha.1'
  
  # JSON解析为对象
  pod 'HandyJSON', '5.0.0-beta.1'
  
  #腾讯IM
  pod 'TUIChat', '6.0.1992'
  
  #个推
  pod 'GTSDK'
  
  # jsbridge
  pod 'WKWebViewJavascriptBridge', '~> 1.2.2'
  
  # eventbus
  pod 'SwiftEventBus', :tag => '5.1.0', :git => 'https://github.com/cesarferreira/SwiftEventBus.git'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
