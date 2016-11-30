//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Zzy on 12/10/2016.
//  Copyright © 2016 Zzy. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import NotificationCenter
import ReachabilitySwift

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var switchButton: UISwitch!
    @IBOutlet private weak var wifiLabel: UILabel!
    @IBOutlet private weak var wifiImageView: UIImageView!
    
    private var reachability: Reachability?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Fabric.with([Answers.self, Crashlytics.self])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachability = Reachability()
        reachability?.whenReachable = { [weak self] Reachability in
            DispatchQueue.main.async {
                self?.updateSSID()
            }
        }
        reachability?.whenUnreachable = { [weak self] Reachability in
            DispatchQueue.main.async {
                self?.updateSSID()
            }
        }
        do {
            try reachability?.startNotifier()
        } catch {
        }
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(updateVPNStatus), name: NSNotification.Name(rawValue: VPNManager.VPNStatusChange), object: nil)
        
        updateInterface()
    }
    
    private func updateInterface() {
        updateVPNStatus()
        updateSSID()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        reachability?.stopNotifier()
        reachability = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    private func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    @objc private func updateSSID() {
        if reachability?.currentReachabilityStatus == .reachableViaWiFi {
            if let ssid = UIDevice.current.SSID {
                wifiLabel.text = ssid
            } else {
                wifiLabel.text = "未知网络"
            }
        } else {
            wifiLabel.text = "未连接Wifi"
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
