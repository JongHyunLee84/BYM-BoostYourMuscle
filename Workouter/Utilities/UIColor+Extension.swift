//
//  UIColor+Extension.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/26.
//

import UIKit

extension UIColor {
    static var dynamicColor: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
    }
    
    static var dynamicBackground: UIColor {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.systemGray6
            } else {
                return UIColor.lightGray
            }
        }
    }
}
