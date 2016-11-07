//
//  StorageManager.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/27.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import RealmSwift

class StorageManager {

    static public let sharedManager = StorageManager()
    private let realm: Realm
    
    private init() {
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.zangzhiya.vpnswitch")?.appendingPathComponent("vpnswitch.realm")
        
        var config = Realm.Configuration()
        config.fileURL = fileURL
        self.realm = try! Realm(configuration: config)
    }
    
    public func insertVPNAccount(_ name: String, server: String, account: String, password: String, secretKey: String, group: String, isAlwaysOnline: Bool) -> VPNAccount? {
        let vpnAccount = VPNAccount()
        vpnAccount.uuid = UUID().uuidString
        vpnAccount.name = name
        vpnAccount.server = server
        vpnAccount.account = account
        vpnAccount.password = password
        vpnAccount.secretKey = secretKey
        vpnAccount.group = group
        vpnAccount.isAlwaysOnline = isAlwaysOnline
        try! realm.write {
            realm.add(vpnAccount)
        }
        return vpnAccount
    }
    
    public func updateVPNAccount(_ uuid: String, name: String, server: String, account: String, password: String, secretKey: String, group: String, isAlwaysOnline: Bool) -> VPNAccount? {
        if let vpnAccount = self.vpnAccount(byUUID: uuid) {
            try! realm.write {
                vpnAccount.name = name
                vpnAccount.server = server
                vpnAccount.account = account
                vpnAccount.password = password
                vpnAccount.secretKey = secretKey
                vpnAccount.group = group
                vpnAccount.isAlwaysOnline = isAlwaysOnline
            }
            return vpnAccount
        }
        return nil
    }
    
    public func setActived(withUUID uuid: String) {
        try! realm.write {
            for vpnAccount in allVPNAccounts {
                if vpnAccount.uuid == uuid {
                    vpnAccount.isActived = true
                } else {
                    vpnAccount.isActived = false
                }
            }
        }
    }
    
    public func vpnAccount(byUUID uuid: String) -> VPNAccount? {
        return realm.objects(VPNAccount.self).filter("uuid = %@", uuid).first
    }
    
    public func deleteVPNAccount(_ uuid: String) -> Void {
        let vpnAccount = self.vpnAccount(byUUID: uuid)
        try! realm.write {
            realm.delete(vpnAccount!)
        }
    }
    
    public var activedVPN: VPNAccount? {
        get {
            return realm.objects(VPNAccount.self).filter("isActived = true").first
        }
    }
    
    public var allVPNAccounts: Results<VPNAccount> {
        get {
            return realm.objects(VPNAccount.self).sorted(byProperty: "createdAt", ascending: false)
        }
    }
    
}
