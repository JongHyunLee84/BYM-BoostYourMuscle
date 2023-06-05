//
//  KeyboardManager.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/05.
//

import UIKit

class KeyboardManager {
    
    private init() {}
    
    static func setupKeyborad(_ view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
}

