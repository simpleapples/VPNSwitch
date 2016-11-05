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
        
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var switchButton: UISwitch!
    @IBOutlet private weak var wifiLabel: UILabel!
    @IBOutlet private weak var wifiImageView: UIImageView!
    
    private var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateSSID), userInfo: nil, repeats: true)
        
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
    
    @objc private func updateSSID() {
        if let ssid = UIDevice.current.SSID {
            wifiLabel.text = ssid
        } else {
            wifiLabel.text = "未知网络"
        }
    }
    
    @objc private func updateVPNStatus() {
        var isOn = false
        var imageName = "IconDisconnected"
        switch VPNManager.sharedManager.status {
        case .disconnected, .invalid:
            statusLabel.text = "未连接"
            imageName = "IconDisconnected"
            isOn = false
        case .connecting:
            statusLabel.text = "正在连接..."
            imageName = "IconConnecting"
            isOn = true
        case .disconnecting:
            statusLabel.text = "正在断开..."
            imageName = "IconConnectinng"
            isOn = true
        case .reasserting:
            statusLabel.text = "正在重连..."
            imageName = "IconConnectinng"
            isOn = true
        case .connected:
            var serverString = ""
            if let activedVPN = StorageManager.sharedManager.activedVPN {
                serverString = " " + activedVPN.name
            }
            statusLabel.text = "已连接" + serverString
            imageName = "IconConnected"
            isOn = true
        }
        wifiImageView.image = UIImage.init(named: imageName)
        if switchButton.isOn != isOn {
            switchButton.isOn = isOn
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
    }
}
