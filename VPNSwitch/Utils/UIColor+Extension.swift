//
//  UIColor+Extension.swift
//  VPNSwitch
//
//  Created by Zzy on 18/10/2016.
//  Copyright © 2016 Zzy. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var successColor: UIColor {
        get {
            return UIColor.init(colorLiteralRed: 92 / 255.0, green: 184 / 255.0, blue: 92 / 255.0, alpha: 1)
        }
    }
    
    class var warningColor: UIColor {
        get {
            return UIColor.init(colorLiteralRed: 236 / 255.0, green: 151 / 255.0, blue: 31 / 255.0, alpha: 1)
        }
    }
    
    class var dangerColor: UIColor {
        get {
            return UIColor.init(colorLiteralRed: 201 / 255.0, green: 48 / 255.0, blue: 44 / 255.0, alpha: 1)
        }
    }
    
}
