//
//  Double+Extension.swift
//  Workouter
//
//  Created by 이종현 on 2023/07/11.
//

import Foundation

extension Double {
    var toString: String {
        self.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(self))" : "\(self)"
    }
}
