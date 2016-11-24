//
//  EditVPNViewController.swift
//  vpnswitch
//
//  Created by Zzy on 16/4/26.
//  Copyright © 2016年 Zzy. All rights reserved.
//

import UIKit
import PopupDialog

class EditVPNViewController: UITableViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var serverTextField: UITextField!
    @IBOutlet private weak var accountTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var secretKeyTextField: UITextField!
    @IBOutlet private weak var groupTextField: UITextField!
    
    var vpnAccount: VPNAccount? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterface()
    }
    
    private func updateInterface() {
        if self.vpnAccount != nil {
            title = "编辑"
        } else {
            title = "创建"
        }
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

    @IBAction private func saveButtonTouchUp(_ sender: AnyObject) {
        let name = nameTextField.text
        let server = serverTextField.text
        let account = accountTextField.text
        let password = passwordTextField.text
        let secretKey = secretKeyTextField.text
        let group = groupTextField.text
        let isAlwaysOnline = true
        
        if (name?.isEmpty ?? true) || (server?.isEmpty ?? true) {
            let popup = PopupDialog(title: "请填写完成", message: "请填写VPN名称和服务器地址", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true, completion: nil)
            let confirmButton = DefaultButton(title: "好的") {
            }
            popup.addButtons([confirmButton])
            self.present(popup, animated: true, completion: nil)
            return
        }
        
        if let vpnAccount = vpnAccount {
            _ = StorageManager.sharedManager.updateVPNAccount(vpnAccount.uuid, name: name!, server: server!, account: account!, password: password!, secretKey: secretKey!, group: group!, isAlwaysOnline: isAlwaysOnline)
        } else {
            let vpnAccount = StorageManager.sharedManager.insertVPNAccount(name!, server: server!, account: account!, password: password!, secretKey: secretKey!, group: group!, isAlwaysOnline: isAlwaysOnline)
            if let vpnAccount = vpnAccount {
                StorageManager.sharedManager.setActived(withUUID: vpnAccount.uuid)
            }
        }

        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension EditVPNViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.vpnAccount != nil {
            return 3
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            let popup = PopupDialog(title: "删除这个VPN？", message: nil, image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: true, completion: nil)
            let destructiveButton = DestructiveButton(title: "删除") {
                StorageManager.sharedManager.deleteVPNAccount((self.vpnAccount?.uuid)!)
                _ = self.navigationController?.popViewController(animated: true)
            }
            let cancelButton = CancelButton(title: "不删除") {
            }
            popup.addButtons([destructiveButton, cancelButton])
            self.present(popup, animated: true, completion: nil)
        } else {
            tableView .deselectRow(at: indexPath, animated: false)
        }
    }
    
}
