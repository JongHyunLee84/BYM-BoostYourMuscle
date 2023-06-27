//
//  CommonProtocols.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/25.
//

import UIKit

protocol BaseViewItemProtocol: AnyObject {
    // 뷰 계층 구조 설정 - ex ) view.addSubview()
    func setupHierarchy()
    
    // constrains 설정 - ex ) snapkit
    func setupConstraints()
    
    // 각종 UI 설정 - ex ) cornerRadius, backgroundColor etc..
    func setupUI()
    
}

//// MARK: - DisposeBag
//protocol DisposeBagProtocol: AnyObject {
//    var disposeBag: DisposeBag { get }
//}

//extension DisposeBagProtocol {
//    var disposeBag: DisposeBag {
//        return DisposeBag()
//    }
//}

// MARK: - Passing Data to view
protocol PassingDataProtocol: AnyObject {
    associatedtype T
    func passData(_ vm: T)
}

// MARK: - Keyboard
protocol KeyboardProtocol: AnyObject {
    func setupKeyborad(_ view: UIView)
}

extension KeyboardProtocol {
    func setupKeyborad(_ view: UIView) {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

