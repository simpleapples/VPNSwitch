//
//  StorageManager.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/27.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import RealmSwift

class StorageManager {

    fileprivate let realm: Realm
    
    static let sharedManager = StorageManager()
    fileprivate init() {
        let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.zangzhiya.vpnswitch")?.appendingPathComponent("vpnswitch.realm")
        
        var config = Realm.Configuration()
        config.fileURL = fileURL
        self.realm = try! Realm(configuration: config)
    }
    
    func insertVPNAccount(_ name: String, server: String, account: String, password: String, secretKey: String, group: String, isAlwaysOnline: Bool) -> VPNAccount? {
        let vpnAccount = VPNAccount()
        vpnAccount.uuid = UUID().uuidString
        vpnAccount.name = name
        vpnAccount.server = server
        vpnAccount.account = account
        vpnAccount.password = password
        vpnAccount.secretKey = secretKey
        vpnAccount.group = group
        vpnAccount.isAlwaysOnline = isAlwaysOnline
        realm.beginWrite()
        realm.add(vpnAccount)
        try! realm.commitWrite()
        return vpnAccount
    }
    
    func updateVPNAccount(_ uuid: String, name: String, server: String, account: String, password: String, secretKey: String, group: String, isAlwaysOnline: Bool) -> VPNAccount? {
        if let vpnAccount = vpnAccount(uuid) {
            realm.beginWrite()
            vpnAccount.name = name
            vpnAccount.server = server
            vpnAccount.account = account
            vpnAccount.password = password
            vpnAccount.secretKey = secretKey
            vpnAccount.group = group
            vpnAccount.isAlwaysOnline = isAlwaysOnline
            try! realm.commitWrite()
            return vpnAccount
        }
        return nil
    }
    
    func setActived(withUUID uuid: String) {
        realm.beginWrite()
        for vpnAccount in allVPNAccounts {
            if vpnAccount.uuid == uuid {
                vpnAccount.isActived = true
            } else {
                vpnAccount.isActived = false
            }
        }
        try! realm.commitWrite()
    }
    
    var activedVPN: VPNAccount? {
        get {
            return realm.objects(VPNAccount.self).filter("isActived = true").first
        }
    }
    
    fileprivate func vpnAccount(_ uuid: String) -> VPNAccount? {
        return realm.objects(VPNAccount.self).filter("uuid = %@", uuid).first
    }
    
    var allVPNAccounts: Results<VPNAccount> {
        get {
            return realm.objects(VPNAccount.self).sorted(byProperty: "createdAt", ascending: false)
        }
    }
    
}
