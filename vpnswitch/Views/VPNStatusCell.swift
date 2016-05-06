//
//  VPNStatusCell.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/26.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit

class VPNStatusCell: UITableViewCell {

    @IBOutlet weak var vpnStatusLabel: UILabel!
    @IBOutlet weak var vpnSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateVPNStatus), name: VPNManager.VPNStatusChange, object: nil)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config() {
        updateVPNStatus()
    }
    
    @objc private func updateVPNStatus() {
        switch VPNManager.sharedManager.status {
        case .Disconnected, .Invalid:
            vpnStatusLabel.text = "未连接"
            vpnSwitch.on = false
        case .Connecting:
            vpnStatusLabel.text = "正在连接..."
            vpnSwitch.on = true
        case .Disconnecting:
            vpnStatusLabel.text = "正在断开..."
            vpnSwitch.on = true
        case .Reasserting:
            vpnStatusLabel.text = "正在重连..."
            vpnSwitch.on = true
        case .Connected:
            vpnStatusLabel.text = "已连接"
            vpnSwitch.on = true
        }
    }

    @IBAction func switchButtonValueChanged(sender: AnyObject) {
        let switcher = sender as! UISwitch
        let status = VPNManager.sharedManager.status
        if switcher.on == true && (status == .Disconnected || status == .Invalid) {
            if let activedVPN = StorageManager.sharedManager.activedVPN {
                VPNManager.sharedManager.setupVPNConfiguration(activedVPN)
                VPNManager.sharedManager.startVPNTunnel()
            }
        }
        if switcher.on == false && (status != .Disconnected && status != .Invalid) {
            VPNManager.sharedManager.stopVPNTunnel()
        }
        updateVPNStatus()
    }
    
}
