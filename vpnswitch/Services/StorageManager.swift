//
//  StorageManager.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/27.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import RealmSwift

class StorageManager {

    private let realm: Realm
    
    static let sharedManager = StorageManager()
    private init() {
        let config = Realm.Configuration()
        config.fileURL!.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("vpnswitch.realm")
        self.realm = try! Realm(configuration: config)
    }
    
    func insertVPNAccount(name: String, server: String, account: String, password: String, secretKey: String, group: String, isAlwaysOnline: Bool) -> VPNAccount? {
        let vpnAccount = VPNAccount()
        vpnAccount.uuid = NSUUID().UUIDString
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
    
    func updateVPNAccount(uuid: String, name: String, server: String, account: String, password: String, secretKey: String, group: String, isAlwaysOnline: Bool) -> VPNAccount? {
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
    
    func setActived(uuid: String) {
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
            return realm.objects(VPNAccount).filter("isActived = true").first
        }
    }
    
    private func vpnAccount(uuid: String) -> VPNAccount? {
        return realm.objects(VPNAccount).filter("uuid = %@", uuid).first
    }
    
    var allVPNAccounts: Results<VPNAccount> {
        get {
            return realm.objects(VPNAccount).sorted("createdAt", ascending: false)
        }
    }
    
}
