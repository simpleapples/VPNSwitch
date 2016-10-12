//
//  VPNManager.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/30.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import Foundation
import NetworkExtension


class VPNManager {
    
    static let VPNStatusChange = "VPNStatusChange"
    static let sharedManager = VPNManager()
    fileprivate init() {
        NEVPNManager.shared().loadFromPreferences { (error: Error?) in
            NotificationCenter.default.addObserver(self, selector: #selector(self.forwardNotification), name: NSNotification.Name.NEVPNStatusDidChange, object: nil)
        }
    }
    
    var status: NEVPNStatus {
        get {
            return NEVPNManager.shared().connection.status
        }
    }
    
    @objc fileprivate func forwardNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: VPNManager.VPNStatusChange), object: nil)
    }
    
    func setupVPNConfiguration(_ vpnAccount: VPNAccount) {
        var vpnProtocol = NEVPNProtocol()
        
        let ipSecProtocol = NEVPNProtocolIPSec()
        ipSecProtocol.useExtendedAuthentication = true
        ipSecProtocol.localIdentifier = vpnAccount.group
        if let secretKeyReference = vpnAccount.secretKeyReference {
            ipSecProtocol.authenticationMethod = .sharedSecret
            ipSecProtocol.sharedSecretReference = secretKeyReference
        } else {
            ipSecProtocol.authenticationMethod = .none
        }
        vpnProtocol = ipSecProtocol
        
        vpnProtocol.disconnectOnSleep = !vpnAccount.isAlwaysOnline
        vpnProtocol.serverAddress = vpnAccount.server
        if !vpnAccount.account.isEmpty {
            vpnProtocol.username = vpnAccount.account
        }
        if let passwordReference = vpnAccount.passwordReference {
            vpnProtocol.passwordReference = passwordReference
        }
        
        NEVPNManager.shared().localizedDescription = vpnAccount.name
        NEVPNManager.shared().protocolConfiguration = vpnProtocol
        
        NEVPNManager.shared().onDemandRules = [NEOnDemandRule]()
        NEVPNManager.shared().isOnDemandEnabled = false
        
        NEVPNManager.shared().isEnabled = true
        NEVPNManager.shared().saveToPreferences(completionHandler: nil)
    }
    
    func deleteVPNConfigurations() {
        NEVPNManager.shared().removeFromPreferences(completionHandler: nil)
    }
    
    func startVPNTunnel() {
        do {
            try NEVPNManager.shared().connection.startVPNTunnel()
        } catch let error as NSError {
            print(error)
        }
    }
    
    func stopVPNTunnel() {
        NEVPNManager.shared().connection.stopVPNTunnel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
