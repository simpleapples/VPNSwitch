//
//  OnDemandViewController.swift
//  VPNSwitch
//
//  Created by Zzy on 10/11/2016.
//  Copyright © 2016 Zzy. All rights reserved.
//

import UIKit
import RealmSwift

class OnDemandViewController: UITableViewController {

    @IBOutlet private weak var rulesTextView: UITextView!
    
    private let allDomainRules = StorageManager.sharedManager.allDomainRules
    private var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = allDomainRules.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            self?.updateInterface()
        }
        
        updateInterface()
    }
    
    private func updateInterface() {
        var domains = [String]()
        for domain in allDomainRules {
            domains.append(domain.url)
        }
        rulesTextView.text = domains.joined(separator: "\n")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        notificationToken?.stop()
    }
    
    @IBAction func saveButtonTouchUp(_ sender: Any) {
        StorageManager.sharedManager.deleteAllDomainRules()
        let domains = rulesTextView.text.components(separatedBy: "\n")
        for domain in domains {
            if domain.characters.count > 0 {
                _ = StorageManager.sharedManager.insertDomainRule(domain)
            }
        }
    }
    
}
