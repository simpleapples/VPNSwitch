//
//  VPNCell.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/26.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit

class VPNCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var activeView: UIView!
    @IBOutlet weak var latencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setLatency(_ milliseconds: UInt) {
        if milliseconds < 300 {
            latencyLabel.textColor = UIColor.successColor
        } else if milliseconds < 600 {
            latencyLabel.textColor = UIColor.warningColor
        } else {
            latencyLabel.textColor = UIColor.dangerColor
        }
        self.latencyLabel.text = String(milliseconds) + "ms"
    }
    
    public func config(_ vpnAccount: VPNAccount) {
        nameLabel.text = vpnAccount.name
        serverLabel.text = vpnAccount.server
        if vpnAccount.isActived {
            activeView.backgroundColor = UIColor(red: 144 / 255.0, green: 19 / 255.0, blue: 254 / 255.0, alpha: 1)
        } else {
            activeView.backgroundColor = UIColor.white
        }
    }

}
