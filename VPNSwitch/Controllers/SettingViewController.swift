//
//  SettingViewController.swift
//  vpnswitch
//
//  Created by Zzy on 16/5/4.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit
import PopupDialog
import AcknowList

class SettingViewController: UITableViewController {
    
    @IBOutlet weak var onDemandSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
    }
    
    private func updateInterface() {
        onDemandSwitch.isOn = UserDefaults.standard.bool(forKey: "onDemand")
    }

    @IBAction private func onDemandSwitchValueChanged(_ sender: Any) {
        UserDefaults.standard.set(onDemandSwitch.isOn, forKey: "onDemand")
        if let activedVPN = StorageManager.sharedManager.activedVPN {
            VPNManager.sharedManager.setupVPNConfiguration(activedVPN)
        }
    }
    
}

extension SettingViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            self.performSegue(withIdentifier: "SettingToOnDemandSegue", sender: nil)
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let popup = PopupDialog(title: "删除「VPN开关」创建所有配置", message: "点击「删除」可以删除「VPN开关」在iOS设置中创建的所有VPN配置文件，其它App和用户自己创建的VPN不受影响", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true, completion: nil)
            let destructiveButton = DestructiveButton(title: "删除") {
                VPNManager.sharedManager.deleteVPNConfigurations()
            }
            let cancelButton = CancelButton(title: "不删除") {
            }
            popup.addButtons([destructiveButton, cancelButton])
            self.present(popup, animated: true, completion: nil)
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let path = Bundle.main.path(forResource: "Pods-VPNSwitch-acknowledgements", ofType: "plist")
                let acknowListViewController = AcknowListViewController(acknowledgementsPlistPath: path)
                if let navigationController = self.navigationController {
                    navigationController.show(acknowListViewController, sender: nil)
                }
            } else if indexPath.row == 1 {
                let appID = "1111804359";
                let url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(appID)")
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            }
        }
    }
    
}
