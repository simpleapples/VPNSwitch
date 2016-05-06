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
    
    var password: String? {
        get {
            if let password = Keychain.passwordString(uuid) {
                return password
            }
            return nil
        }
        set {
            if newValue != nil {
                Keychain.savePassword(newValue!, uuid: uuid)
            }
        }
    }
    
    var secretKey: String? {
        get {
            if let secretKey = Keychain.secretKeyString(uuid) {
                return secretKey
            }
            return nil
        }
        set {
            if newValue != nil {
                Keychain.saveSecretKey(newValue!, uuid: uuid)
            }
        }
    }
    var passwordRef: NSData? {
        get {
            if let passwordRef = Keychain.passwordData(uuid) {
                return passwordRef
            }
            return nil
        }
    }
    var secretKeyRef: NSData? {
        get {
            if let secretKeyRef = Keychain.secretKeyData(uuid) {
                return secretKeyRef
            }
            return nil
        }
    }
    
    override static func primaryKey() -> String {
        return "uuid"
    }
    
}
