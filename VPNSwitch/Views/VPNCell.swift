//
//  VPNCell.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/26.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit

class VPNCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var serverLabel: UILabel!
    @IBOutlet private weak var activeView: UIView!
    @IBOutlet private weak var latencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setLatency(_ milliseconds: Int) {
        if milliseconds == -1 {
            latencyLabel.textColor = UIColor.black
            latencyLabel.text = "-- ms"
        } else {
            if milliseconds < 300 {
                latencyLabel.textColor = UIColor.successColor
            } else if milliseconds < 600 {
                latencyLabel.textColor = UIColor.warningColor
            } else {
                latencyLabel.textColor = UIColor.dangerColor
            }
            latencyLabel.text = String(milliseconds) + "ms"
        }
    }
    
    public func config(withVPNAccount vpnAccount: VPNAccount) {
        nameLabel.text = vpnAccount.name
        serverLabel.text = vpnAccount.server
        if vpnAccount.isActived {
            activeView.backgroundColor = UIColor(red: 27 / 255.0, green: 160 / 255.0, blue: 252 / 255.0, alpha: 1)
            latencyLabel.isHidden = false
        } else {
            activeView.backgroundColor = UIColor.white
            latencyLabel.isHidden = true
        }
    }

}
