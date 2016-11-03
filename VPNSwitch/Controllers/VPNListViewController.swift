//
//  VPNListViewController.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/26.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit
import RealmSwift
import PlainPing

let VPNStatusCellIdentifier = "VPNStatusCell"
let VPNCellIdentifier = "VPNCell"

class VPNListViewController: UITableViewController {
    
    var allVPNs = StorageManager.sharedManager.allVPNAccounts
    var notificationToken: NotificationToken? = nil
    var selectedIndexPath: IndexPath? = nil
    var timer: Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = true
        
        notificationToken = allVPNs.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.tableView.reloadData()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateLatency), userInfo: nil, repeats: true)
    }
    
    @objc private func updateLatency() {
        for indexPath in tableView.indexPathsForVisibleRows! as [IndexPath] {
            if indexPath.section == 1 {
                let vpn = allVPNs[(indexPath.row)]
                let cell = tableView.cellForRow(at: indexPath) as! VPNCell
                if vpn.isActived {
                    PlainPing.ping(vpn.server, withTimeout: 2.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
                        if let latency = timeElapsed {
                            cell.setLatency(Int(latency))
                        }
                    })
                } else {
                    cell.setLatency(-1)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedIndexPath != nil {
            let vpnAccount = allVPNs[((selectedIndexPath as NSIndexPath?)?.row)!]
            if segue.destination.isKind(of: EditVPNViewController.self) {
                let editVPNViewController = segue.destination as! EditVPNViewController
                editVPNViewController.vpnAccount = vpnAccount
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        notificationToken?.stop()
        timer?.invalidate()
        timer = nil
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return allVPNs.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VPNStatusCellIdentifier, for: indexPath) as! VPNStatusCell
            cell.config()
            return cell
        } else if (indexPath as NSIndexPath).section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VPNCellIdentifier, for: indexPath) as! VPNCell
            cell.config(allVPNs[(indexPath as NSIndexPath).row])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 50
        } else if (indexPath as NSIndexPath).section == 1 {
            return 100
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vpnAccount = allVPNs[(indexPath as NSIndexPath).row]
        StorageManager.sharedManager.setActived(vpnAccount.uuid)
        for vpn in allVPNs {
            let cell = tableView.cellForRow(at: indexPath) as! VPNCell
            cell.setLatencyHidden(!vpn.isActived)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "VPNListToEditVPNSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - EventHandler

    @IBAction func addVPNButtonTouchUp(_ sender: AnyObject) {
        selectedIndexPath = nil
        performSegue(withIdentifier: "VPNListToEditVPNSegue", sender: sender)
    }
    
}
