//
//  EditVPNViewController.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/26.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit

class EditVPNViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var secretKeyTextField: UITextField!
    @IBOutlet weak var groupTextField: UITextField!
    
    var vpnAccount: VPNAccount? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
    }
    
    private func updateInterface() {
        if let vpnAccount = vpnAccount {
            nameTextField.text = vpnAccount.name
            serverTextField.text = vpnAccount.server
            accountTextField.text = vpnAccount.account
            passwordTextField.text = vpnAccount.password
            secretKeyTextField.text = vpnAccount.secretKey
            groupTextField.text = vpnAccount.group
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - EventHandler

    @IBAction func saveButtonTouchUp(sender: AnyObject) {
        let name = nameTextField.text
        let server = serverTextField.text
        let account = accountTextField.text
        let password = passwordTextField.text
        let secretKey = secretKeyTextField.text
        let group = groupTextField.text
        let isAlwaysOnline = true
        
        if let vpnAccount = vpnAccount {
            StorageManager.sharedManager.updateVPNAccount(vpnAccount.uuid, name: name!, server: server!, account: account!, password: password!, secretKey: secretKey!, group: group!, isAlwaysOnline: isAlwaysOnline)
        } else {
            StorageManager.sharedManager.insertVPNAccount(name!, server: server!, account: account!, password: password!, secretKey: secretKey!, group: group!, isAlwaysOnline: isAlwaysOnline)
        }

        navigationController?.popViewControllerAnimated(true)
    }
    
}
