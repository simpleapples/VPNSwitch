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
    
    static func savePassword(_ password: String, uuid: String) -> Bool {
        let key = uuid + "-password"
        KeychainWrapper.standard.removeObject(forKey: key)
        return KeychainWrapper.standard.set(password, forKey: key)
    }
    
    static func saveSecretKey(_ secretKey: String, uuid: String) -> Bool {
        let key = uuid + "-secretKey"
        KeychainWrapper.standard.removeObject(forKey: key)
        return KeychainWrapper.standard.set(secretKey, forKey: key)
    }
    
    static func passwordDataReference(_ uuid: String) -> Data? {
        let key = uuid + "-password"
        return KeychainWrapper.standard.dataRef(forKey: key)
    }
    
    static func secretKeyDataReference(_ uuid: String) -> Data? {
        let key = uuid + "-secretKey"
        return KeychainWrapper.standard.dataRef(forKey: key)
    }
    
    static func passwordString(_ uuid: String) -> String? {
        let key = uuid + "-password"
        return KeychainWrapper.standard.string(forKey: key)
    }
    
    static func secretKeyString(_ uuid: String) -> String? {
        let key = uuid + "-secretKey"
        return KeychainWrapper.standard.string(forKey: key)
    }
    
}
