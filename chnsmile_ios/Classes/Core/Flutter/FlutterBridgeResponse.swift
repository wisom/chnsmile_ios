//
//  FlutterBridgeResponse.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/26.
//

import Foundation

typealias FlutterRespStatus = Int

struct FlutterBridgeResponse : Codable{
    var code:FlutterRespStatus
    var data:String?
    var msg:String?
}
