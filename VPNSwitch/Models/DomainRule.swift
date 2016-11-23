//
//  DomainRule.swift
//  VPNSwitch
//
//  Created by Zzy on 23/11/2016.
//  Copyright © 2016 Zzy. All rights reserved.
//

import RealmSwift

class DomainRule: Object {
    
    dynamic var uuid = ""
    dynamic var url = ""
    dynamic var createdAt = Date()
    
    override static func primaryKey() -> String {
        return "uuid"
    }
    
}
