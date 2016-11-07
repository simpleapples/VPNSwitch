//
//  SettingViewController.swift
//  vpnswitch
//
//  Created by Zzy on 16/5/4.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    override func viewDidLoad() {
        
    }

}

extension SettingViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 0 {
            VPNManager.sharedManager.deleteVPNConfigurations()
        }
    }
    
}
