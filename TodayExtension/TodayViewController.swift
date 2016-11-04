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
        updateInterface()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateVPNStatus), name: NSNotification.Name(rawValue: VPNManager.VPNStatusChange), object: nil)
    }
    
    private func updateInterface() {
        updateVPNStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    @objc private func updateVPNStatus() {
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
            var serverString = ""
            if let activedVPN = StorageManager.sharedManager.activedVPN {
                serverString = " " + activedVPN.name
            }
            statusLabel.text = "已连接" + serverString
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
