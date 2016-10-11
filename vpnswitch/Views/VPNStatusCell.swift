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
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateVPNStatus), name: NSNotification.Name(rawValue: VPNManager.VPNStatusChange), object: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config() {
        updateVPNStatus()
    }
    
    @objc fileprivate func updateVPNStatus() {
        switch VPNManager.sharedManager.status {
        case .disconnected, .invalid:
            vpnStatusLabel.text = "未连接"
            vpnSwitch.isOn = false
        case .connecting:
            vpnStatusLabel.text = "正在连接..."
            vpnSwitch.isOn = true
        case .disconnecting:
            vpnStatusLabel.text = "正在断开..."
            vpnSwitch.isOn = true
        case .reasserting:
            vpnStatusLabel.text = "正在重连..."
            vpnSwitch.isOn = true
        case .connected:
            vpnStatusLabel.text = "已连接"
            vpnSwitch.isOn = true
        }
    }

    @IBAction func switchButtonValueChanged(_ sender: AnyObject) {
        let switcher = sender as! UISwitch
        let status = VPNManager.sharedManager.status
        if switcher.isOn == true && (status == .disconnected || status == .invalid) {
            if let activedVPN = StorageManager.sharedManager.activedVPN {
                VPNManager.sharedManager.setupVPNConfiguration(activedVPN)
                VPNManager.sharedManager.startVPNTunnel()
            }
        }
        if switcher.isOn == false && (status != .disconnected && status != .invalid) {
            VPNManager.sharedManager.stopVPNTunnel()
        }
        updateVPNStatus()
    }
    
}
