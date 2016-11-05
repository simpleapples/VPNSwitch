//
//  VPNStatusCell.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/26.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit

protocol VPNStatusCellDelegate: class {
    
    func statusCell(_ cell: VPNStatusCell, switchButtonChanged sender:AnyObject)
}

class VPNStatusCell: UITableViewCell {
    
    @IBOutlet private weak var switchButton: UISwitch!
    @IBOutlet private weak var statusLabel: UILabel!
    
    public weak var delegate: VPNStatusCellDelegate?
    
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
    
    public func config() {
        updateVPNStatus()
    }
    
    @objc public func updateVPNStatus() {
        var isOn = false
        switch VPNManager.sharedManager.status {
        case .disconnected, .invalid:
            statusLabel.text = "未连接"
            isOn = false
        case .connecting:
            statusLabel.text = "正在连接..."
            isOn = true
        case .disconnecting:
            statusLabel.text = "正在断开..."
            isOn = true
        case .reasserting:
            statusLabel.text = "正在重连..."
            isOn = true
        case .connected:
            statusLabel.text = "已连接"
            isOn = true
        }
        if switchButton.isOn != isOn {
            switchButton.isOn = isOn
        }
    }

    @IBAction private func switchButtonValueChanged(_ sender: AnyObject) {
        delegate?.statusCell(self, switchButtonChanged: sender)
    }
    
}
