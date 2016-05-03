//
//  KeychainServices.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/30.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class Keychain {
    
    static let ServiceName = "com.zangzhiya.vpnswitch"
    
    static func savePassword(password: String, uuid: String) -> Bool {
        let key = uuid + "-password"
        KeychainWrapper.serviceName = ServiceName
        KeychainWrapper.removeObjectForKey(key)
        return KeychainWrapper.setString(password, forKey: key)
    }
    
    static func saveSecretKey(secretKey: String, uuid: String) -> Bool {
        let key = uuid + "-secretKey"
        KeychainWrapper.serviceName = ServiceName
        KeychainWrapper.removeObjectForKey(key)
        return KeychainWrapper.setString(secretKey, forKey: key)
    }
    
    static func passwordData(uuid: String) -> NSData? {
        let key = uuid + "-password"
        KeychainWrapper.serviceName = ServiceName
        return KeychainWrapper.dataForKey(key)
    }
    
    static func secretKeyData(uuid: String) -> NSData? {
        let key = uuid + "-secretKey"
        KeychainWrapper.serviceName = ServiceName
        return KeychainWrapper.dataForKey(key)
    }
    
    static func passwordString(uuid: String) -> String? {
        let key = uuid + "-password"
        KeychainWrapper.serviceName = ServiceName
        return KeychainWrapper.stringForKey(key)
    }
    
    static func secretKeyString(uuid: String) -> String? {
        let key = uuid + "-secretKey"
        KeychainWrapper.serviceName = ServiceName
        return KeychainWrapper.stringForKey(key)
    }
    
}