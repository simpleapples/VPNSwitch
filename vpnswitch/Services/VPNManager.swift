//
//  VPNManager.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/30.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import Foundation
import NetworkExtension

enum VPNStatus {
    case NotConnected
    case Connecting
    case Connected
}

class VPNManager {
    
    let VPNStatusChanged: String = "VPNStatusChanged"
    private var _status: VPNStatus = .NotConnected
    var status: VPNStatus {
        get {
            return _status
        }
        set {
            _status = newValue
            NSNotificationCenter.defaultCenter().postNotificationName(VPNStatusChanged, object: nil)
        }
    }
    
    static let sharedManager = VPNManager()
    private init() {

    }
    
    func crateVPNConfiguration(vpnAccount: VPNAccount) {
        let ipSecProtocol = NEVPNProtocolIPSec()
        ipSecProtocol.authenticationMethod = .SharedSecret
        ipSecProtocol.serverAddress = vpnAccount.server
        ipSecProtocol.username = vpnAccount.account
        ipSecProtocol.passwordReference = Keychain.passwordData(vpnAccount.uuid)
        ipSecProtocol.sharedSecretReference = Keychain.secretKeyData(vpnAccount.uuid)
        ipSecProtocol.disconnectOnSleep = !vpnAccount.isAlwaysOnline
        
        ipSecProtocol.useExtendedAuthentication = true
        ipSecProtocol.localIdentifier = vpnAccount.group
        ipSecProtocol.remoteIdentifier = vpnAccount.group
        
        NEVPNManager.sharedManager().protocolConfiguration = ipSecProtocol
        NEVPNManager.sharedManager().onDemandEnabled = true
        NEVPNManager.sharedManager().localizedDescription = vpnAccount.name
    }
    
    func deleteVPNConfigurations() {
        NEVPNManager.sharedManager().loadFromPreferencesWithCompletionHandler { (error: NSError?) in
            NEVPNManager.sharedManager().removeFromPreferencesWithCompletionHandler(nil)
        }
    }
    
    func startVPNTunnel() {
        NEVPNManager.sharedManager().loadFromPreferencesWithCompletionHandler { (error: NSError?) in
            if error == nil {
                do {
                    try NEVPNManager.sharedManager().connection.startVPNTunnel()
                    self.status = .Connected
                } catch {
                    self.status = .NotConnected
                }
            }
        }
    }
    
    func stopVPNTunnel() {
        NEVPNManager.sharedManager().loadFromPreferencesWithCompletionHandler { (error: NSError?) in
            if error == nil {
                NEVPNManager.sharedManager().connection.stopVPNTunnel()
                self.status = .NotConnected
            }
        }
    }
    
}