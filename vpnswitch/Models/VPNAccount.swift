//
//  VPNAccount.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/26.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import RealmSwift

class VPNAccount: Object {
    
    dynamic var uuid = ""
    dynamic var name = ""
    dynamic var server = ""
    dynamic var account = ""
    dynamic var group = ""
    dynamic var isAlwaysOnline = false
    dynamic var createdAt = NSDate()
    dynamic var isActived = false
    
    var password: String {
        get {
            if let password = Keychain.passwordString(uuid) {
                return password
            }
            return ""
        }
        set {
            Keychain.savePassword(newValue, uuid: uuid)
        }
    }
    
    var secretKey: String {
        get {
            if let secretKey = Keychain.secretKeyString(uuid) {
                return secretKey
            }
            return ""
        }
        set {
            Keychain.saveSecretKey(newValue, uuid: uuid)
        }
    }
    
    override static func primaryKey() -> String {
        return "uuid"
    }
    
}
