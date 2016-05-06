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
    private init() {
        NEVPNManager.sharedManager().loadFromPreferencesWithCompletionHandler { (error: NSError?) in
            
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(forwardNotification), name: NEVPNStatusDidChangeNotification, object: nil)
    }
    
    var status: NEVPNStatus {
        get {
            return NEVPNManager.sharedManager().connection.status
        }
    }
    
    @objc private func forwardNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(VPNManager.VPNStatusChange, object: nil)
    }
    
    func setupVPNConfiguration(vpnAccount: VPNAccount) {
        var vpnProtocol = NEVPNProtocol()
        
        let ipSecProtocol = NEVPNProtocolIPSec()
        ipSecProtocol.useExtendedAuthentication = true
        ipSecProtocol.localIdentifier = vpnAccount.group
        if let secretKeyRef = vpnAccount.secretKeyRef {
            ipSecProtocol.authenticationMethod = .SharedSecret
            ipSecProtocol.sharedSecretReference = secretKeyRef
        } else {
            ipSecProtocol.authenticationMethod = .None
        }
        vpnProtocol = ipSecProtocol
        
        vpnProtocol.disconnectOnSleep = !vpnAccount.isAlwaysOnline
        vpnProtocol.serverAddress = vpnAccount.server
        if !vpnAccount.account.isEmpty {
            vpnProtocol.username = vpnAccount.account
        }
        if let passwordRef = vpnAccount.passwordRef {
            vpnProtocol.passwordReference = passwordRef
        }
        
        NEVPNManager.sharedManager().localizedDescription = vpnAccount.name
        NEVPNManager.sharedManager().enabled = true
        NEVPNManager.sharedManager().protocolConfiguration = vpnProtocol
        
        NEVPNManager.sharedManager().onDemandRules = [NEOnDemandRule]()
        NEVPNManager.sharedManager().onDemandEnabled = false
        
        NEVPNManager.sharedManager().saveToPreferencesWithCompletionHandler(nil)
    }
    
    func deleteVPNConfigurations() {
        NEVPNManager.sharedManager().removeFromPreferencesWithCompletionHandler(nil)
    }
    
    func startVPNTunnel() {
        do {
            try NEVPNManager.sharedManager().connection.startVPNTunnel()
        } catch {
        }
    }
    
    func stopVPNTunnel() {
        NEVPNManager.sharedManager().connection.stopVPNTunnel()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}