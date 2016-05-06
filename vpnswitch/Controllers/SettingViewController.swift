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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            VPNManager.sharedManager.deleteVPNConfigurations()
        }
    }

}
