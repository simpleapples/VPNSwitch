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
    
    static let keychainWrapper = KeychainWrapper(serviceName: Bundle.main.bundleIdentifier!, accessGroup: "group.com.zangzhiya.vpnswitch")
    
    static func savePassword(_ password: String, uuid: String) -> Bool {
        let key = uuid + "-password"
        keychainWrapper.removeObject(forKey: key)
        return keychainWrapper.set(password, forKey: key)
    }
    
    static func saveSecretKey(_ secretKey: String, uuid: String) -> Bool {
        let key = uuid + "-secretKey"
        keychainWrapper.removeObject(forKey: key)
        return keychainWrapper.set(secretKey, forKey: key)
    }
    
    static func passwordDataReference(_ uuid: String) -> Data? {
        let key = uuid + "-password"
        return keychainWrapper.dataRef(forKey: key)
    }
    
    static func secretKeyDataReference(_ uuid: String) -> Data? {
        let key = uuid + "-secretKey"
        return keychainWrapper.dataRef(forKey: key)
    }
    
    static func passwordString(_ uuid: String) -> String? {
        let key = uuid + "-password"
        return keychainWrapper.string(forKey: key)
    }
    
    static func secretKeyString(_ uuid: String) -> String? {
        let key = uuid + "-secretKey"
        return keychainWrapper.string(forKey: key)
    }
    
}
