//
//  VPNListViewController.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/26.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit
import RealmSwift

let VPNStatusCellIdentifier = "VPNStatusCell"
let VPNCellIdentifier = "VPNCell"

class VPNListViewController: UITableViewController {
    
    var allVPNs = StorageManager.sharedManager.allVPNAccounts
    var notificationToken: NotificationToken? = nil
    var selectedIndexPath: NSIndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = true
        
        notificationToken = allVPNs.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if selectedIndexPath != nil {
            let vpnAccount = allVPNs[(selectedIndexPath?.row)!]
            if segue.destinationViewController.isKindOfClass(EditVPNViewController) {
                let editVPNViewController = segue.destinationViewController as! EditVPNViewController
                editVPNViewController.vpnAccount = vpnAccount
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        notificationToken?.stop()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return allVPNs.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(VPNStatusCellIdentifier, forIndexPath: indexPath) as! VPNStatusCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(VPNCellIdentifier, forIndexPath: indexPath) as! VPNCell
            cell.config(allVPNs[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else if indexPath.section == 1 {
            return 100
        }
        return 50
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vpnAccount = allVPNs[indexPath.row]
        StorageManager.sharedManager.setActived(vpnAccount.uuid)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        performSegueWithIdentifier("VPNListToEditVPNSegue", sender: nil)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 5
    }
    
    // MARK: - EventHandler

    @IBAction func addVPNButtonTouchUp(sender: AnyObject) {
        selectedIndexPath = nil
        performSegueWithIdentifier("VPNListToEditVPNSegue", sender: sender)
    }
    
}
