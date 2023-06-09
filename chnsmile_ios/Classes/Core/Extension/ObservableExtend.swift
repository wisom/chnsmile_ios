//
//  ObservableExtend.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import Foundation

import RxSwift
import HandyJSON
import Moya

//MARK: - 自定义 错误
/// 自定义错误
///
/// - objectMapping: 表示JSON解析为对象失败
public enum IxueaError: Swift.Error {
    case objectMapping
}

// MARK: - 扩展Observable
extension Observable {

    /// 将字符串解析为对象
    ///
    /// - Parameter type: 要转为的类
    /// - Returns: 转换后的观察者对象
    public func mapObject<T:HandyJSON>(_ type: T.Type) -> Observable<T?> {
        return self.map({ data in
            //将参数尝试转为字符串

            guard let dataString = data as? String else {
                //data不能转为字符串
                return nil
            }

            if dataString.isEmpty {
                // 空字符串
                return nil
            }

            guard let result = type.deserialize(from: dataString) else {
                //转为对象失败
                throw IxueaError.objectMapping
            }

            // 解析成功
            return result
        })
    }
}

public class HttpObserver<Element>: ObserverType {

    /// ObserverType协议中用到了泛型E
    /// 所以说子类中就要指定E这个泛型
    /// 不然就会报错
    public typealias E = Element

    var onSuccess: (E) -> Void

    var onError: ((BaseResponse?, Error?) -> Bool)?

    /// 构造方法
    ///
    /// - Parameters:
    ///   - onSuccess: 请求成功的回调
    ///   - onError: 请求失败的回调
    init(_ onSuccess: @escaping((E) -> Void), _ onError: ((BaseResponse?, Error?) -> Bool)?) {
        self.onSuccess = onSuccess
        self.onError = onError
    }

    /// 当RxSwift框架里面发送了事件回调
    public func on(_ event: Event<Element>) {
        switch event {
        case .next(let value):
            //next事件
            print("HttpObserver next:\(value)")

            let baseResponse = value as? BaseResponse

            if let code = baseResponse?.code {
                //有状态码
                //表示请求出错了
                if (code != 200) {
                    requestErrorHandler(baseResponse: baseResponse)
                } else {
                    onSuccess(value)
                }
            } else {
                onSuccess(value)
            }
        case .error(let error):
            //请求失败
            print("HttpObserver error:\(error)")

            //处理错误
            requestErrorHandler(error: error)

        case .completed:
            //请求完成
            print("HttpObserver completed")
        }
    }

    func requestErrorHandler(baseResponse: BaseResponse? = nil, error: Error? = nil) {

        if onError != nil && onError!(baseResponse, error) {
            //回调了请求失败方法
            //并且该方法返回了true
            print("error1: ")
            //返回true就表示外部手动处理错误
            //那我们框架内部就不用做任何事情了
        } else {
            print("error2: ")
            //要自动处理错误
            HttpUtil.handlerRequest(baseResponse: baseResponse, error: error)
        }
    }
}

// MARK: - 扩展ObservableType
// 目的是添加两个自定义监听方法
// 一个是只观察请求成功的方法
// 一个既可以观察请求成功也可以观察请求失败
extension ObservableType {
    
    /// 观察成功和失败事件
    ///
    /// - Parameters:
    ///   - onSuccess: 请求成功的回调
    ///   - onError: 请求失败的回调
    func subscribe(
        _ onSuccess: @escaping ((E) -> Void),
        _ onError: @escaping((BaseResponse?, Error?) -> Bool)
    ) -> Disposable {

        //创建一个Disposable
        let disposable = Disposables.create()

        // 创建一个HttpObserver， 相当于 源码中的AnonymousObserver
        let observer = HttpObserver<E>(onSuccess, onError)

        // c创建 并返回 d一个 Disposable

        return Disposables.create(
            self.asObservable().subscribe(observer),
            disposable
        )
    }
    
    /// 观察成功的事件
    func subscribeOnSuccess(_ onSuccess: @escaping ((E) -> Void)) -> Disposable {
        //创建一个Disposable
        let disposable = Disposables.create()

        // 创建一个HttpObserver， 相当于 源码中的AnonymousObserver
        let observer = HttpObserver<E>(onSuccess, nil)

        // 创建 并返回 d一个 Disposable
        return Disposables.create(
            self.asObservable().subscribe(observer),
            disposable
        )
    }
}

