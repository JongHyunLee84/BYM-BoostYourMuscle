//
//  UIView+Extension.swift
//  Workouter
//
//  Created by 이종현 on 2023/05/31.
//

import Foundation
import UIKit
final class CommonUI {
    
    private init() {}
    
    static func uiButtonWillReturned(title t: String, fontSize s: CGFloat? = nil, target: Any? = nil, action a: Selector? = nil) -> UIButton {
        let bt = UIButton(type: .system)
        bt.setTitle(t, for: .normal)
        if let s {
            bt.titleLabel?.font = .systemFont(ofSize: s)
        }
        bt.setTitleColor(.black, for: .normal)
        bt.backgroundColor = .opaqueSeparator
        bt.layer.cornerRadius = 8
        bt.layer.masksToBounds = true
        if let target, let a {
            bt.addTarget(target, action: a, for: .touchUpInside)
        }
        
        return bt
    }
    
    static func uiImageButtonWillReturned(_ name: String, size: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale) -> UIButton {
        let bt = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: size,
                                                      weight: weight,
                                                      scale: scale)
        let ellipsis = UIImage(systemName: name, withConfiguration: largeConfig)
        bt.setImage(ellipsis, for: .normal)
        bt.tintColor = .black
        return bt
    }

    static func uiTextFieldWillReturned(placeholder p: String? = nil, text t: String? = nil, tag: Int = 0) -> UITextField {
        let tf = UITextField()
        tf.placeholder = p
        tf.text = t
        tf.font = .systemFont(ofSize: 15, weight: .medium)
        tf.backgroundColor = .quaternarySystemFill
        tf.textAlignment = .center
        tf.layer.cornerRadius = 8
        tf.layer.masksToBounds = true
        tf.tag = tag
        return tf
    }

    static func uiLabelWillReturned(title t: String, size: CGFloat = 15, weight: UIFont.Weight = .black) -> UILabel {
        let lb = UILabel()
        lb.text = t
        lb.font = .systemFont(ofSize: size, weight: weight)
        return lb
    }
    
    static func uiStackViewWillReturned(views vs: [UIView], alignment ali: UIStackView.Alignment = .center, axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 20) -> UIStackView {
        let stv = UIStackView(arrangedSubviews: vs)
        stv.axis = axis
        stv.alignment = ali
        stv.spacing = spacing 
        stv.distribution = .fillEqually
        return stv
    }
}
    

