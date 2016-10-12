//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Zzy on 12/10/2016.
//  Copyright © 2016 Zzy. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    private func updateVPNStatus() {
        switch VPNManager.sharedManager.status {
        case .disconnected, .invalid:
            statusLabel.text = "未连接"
            switchButton.isOn = false
        case .connecting:
            statusLabel.text = "正在连接..."
            switchButton.isOn = true
        case .disconnecting:
            statusLabel.text = "正在断开..."
            switchButton.isOn = true
        case .reasserting:
            statusLabel.text = "正在重连..."
            switchButton.isOn = true
        case .connected:
            statusLabel.text = "已连接"
            switchButton.isOn = true
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
