//
//  DeviceUtil.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/26.
//

import Foundation

class DeviceUtil {
    
    static func getDeiveInfo() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {return identifier}
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
