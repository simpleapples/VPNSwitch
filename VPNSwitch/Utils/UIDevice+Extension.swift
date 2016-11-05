//
//  UIDevice+Extension.swift
//  VPNSwitch
//
//  Created by Zzy on 05/11/2016.
//  Copyright © 2016 Zzy. All rights reserved.
//

import UIKit
import CoreFoundation
import SystemConfiguration.CaptiveNetwork

extension UIDevice {
    
    public var SSID: String? {
        get {
            let interfaces = CNCopySupportedInterfaces()
            if interfaces == nil {
                return nil
            }
            
            let interfacesArray = interfaces as! [String]
            if interfacesArray.count <= 0 {
                return nil
            }
            
            let interfaceName = interfacesArray[0] as String
            let unsafeInterfaceData =     CNCopyCurrentNetworkInfo(interfaceName as CFString)
            if unsafeInterfaceData == nil {
                return nil
            }
            
            let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
            
            return interfaceData["SSID"] as? String
        }
    }
    
}
